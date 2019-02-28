require 'spec_helper'

RSpec.describe Responders::PaginateResponder, type: :controller do
  case $gem
    when 'will_paginate',
         'pagy'
      let(:array_resource) do
        ('AA'..'zz').to_a
      end
    when 'kaminari'
      let(:array_resource) do
        Kaminari.paginate_array ('AA'..'zz').to_a
      end
  end

  before do
    if ActiveRecord::VERSION::MAJOR >= 4
      self.resource = ArModel.all
    else
      self.resource = ArModel.scoped
    end
  end

  let(:method)   { :get }
  let(:response) { action.call; @response }
  let(:json)     { JSON.parse response.body }
  let(:params)   { {format: :json} }

  if ActionPack::VERSION::MAJOR >= 5
    let(:action)   { -> { send(method, :index, params: params) } }
  else
    let(:action)   { -> { send(method, :index, params) } }
  end

  context 'with AR resource' do
    it { expect(json).to eq (1..50).to_a }

    describe '?page' do
      let(:params) { super().merge page: 2 }

      it { expect(json).to eq (51..100).to_a }
    end

    describe '?page empty' do
      let(:params) { super().merge page: '' }

      it 'responds with first page' do
        expect(json).to eq (1..50).to_a
      end
    end

    describe '?page invalid' do
      let(:params) { super().merge page: 'foobar' }

      it 'responds with first page' do
        expect(json).to eq (1..50).to_a
      end
    end

    describe '?per_page' do
      let(:params) { super().merge per_page: 10 }

      it { expect(json).to eq (1..10).to_a }
    end

    describe '?per_page&page' do
      let(:params) { super().merge page: 2, per_page: 10 }

      it { expect(json).to eq (11..20).to_a }
    end
  end

  context 'with array resource' do
    before { @controller.resource = array_resource }

    it { expect(json).to eq ('AA'..'zz').to_a[0..49] }

    describe '?page' do
      let(:params) { super().merge page: 2 }

      it { expect(json).to eq ('AA'..'zz').to_a[50..99] }
    end

    describe '?per_page' do
      let(:params) { super().merge per_page: 10 }

      it { expect(json).to eq ('AA'..'zz').to_a[0..9] }
    end

    describe '?per_page&page' do
      let(:params) { super().merge page: 2, per_page: 10 }

      it { expect(json).to eq ('AA'..'zz').to_a[10..19] }
    end
  end

  context 'with AR association' do
    before { @controller.resource = ArModel.find(1).ar_assoc_models }

    it { expect(json).to eq (1..5).to_a }
  end

  describe 'links' do
    subject { response.links.map{|l| [l[:params][:rel], l[:url]]}.to_h }

    it { expect(subject.size).to eq 3 }
    it { is_expected.to include 'first' => 'http://test.host/index.json?page=1'  }
    it { is_expected.to include 'next'  => 'http://test.host/index.json?page=2'  }
    it { is_expected.to include 'last'  => 'http://test.host/index.json?page=14' }

    context '?page' do
      let(:params) { super().merge page: 2 }

      it { expect(subject.size).to eq 4 }
      it { is_expected.to include 'first' => 'http://test.host/index.json?page=1'  }
      it { is_expected.to include 'prev'  => 'http://test.host/index.json?page=1'  }
      it { is_expected.to include 'next'  => 'http://test.host/index.json?page=3'  }
      it { is_expected.to include 'last'  => 'http://test.host/index.json?page=14' }
    end

    context '?page=5' do
      let(:params) { super().merge page: 5 }

      it { expect(subject.size).to eq 4 }
      it { is_expected.to include 'first' => 'http://test.host/index.json?page=1'  }
      it { is_expected.to include 'prev'  => 'http://test.host/index.json?page=4'  }
      it { is_expected.to include 'next'  => 'http://test.host/index.json?page=6'  }
      it { is_expected.to include 'last'  => 'http://test.host/index.json?page=14' }
    end

    context '?page last' do
      let(:params) { super().merge page: 14 }

      it { expect(subject.size).to eq 3 }
      it { is_expected.to include 'first' => 'http://test.host/index.json?page=1'  }
      it { is_expected.to include 'prev'  => 'http://test.host/index.json?page=13' }
      it { is_expected.to include 'last'  => 'http://test.host/index.json?page=14' }
    end

    context '?page before last' do
      let(:params) { super().merge page: 13 }

      it { expect(subject.size).to eq 4 }
      it { is_expected.to include 'first' => 'http://test.host/index.json?page=1'  }
      it { is_expected.to include 'prev'  => 'http://test.host/index.json?page=12' }
      it { is_expected.to include 'next'  => 'http://test.host/index.json?page=14' }
      it { is_expected.to include 'last'  => 'http://test.host/index.json?page=14' }
    end

    context '?per_page' do
      let(:params) { super().merge page: 1, per_page: 10 }

      it { expect(subject.size).to eq 3 }
      it { is_expected.to include 'first' => 'http://test.host/index.json?page=1&per_page=10'  }
      it { is_expected.to include 'next'  => 'http://test.host/index.json?page=2&per_page=10'  }
      it { is_expected.to include 'last'  => 'http://test.host/index.json?page=68&per_page=10' }
    end

    context '?per_page above max per page limit' do
      let(:params) { super().merge page: 1, per_page: 100 }

      it { expect(subject.size).to eq 3 }
      it { is_expected.to include 'first' => 'http://test.host/index.json?page=1&per_page=50'  }
      it { is_expected.to include 'next'  => 'http://test.host/index.json?page=2&per_page=50'  }
      it { is_expected.to include 'last'  => 'http://test.host/index.json?page=14&per_page=50' }
    end

    context 'when method is HEAD' do
      let(:method) { :head }

      it { expect(subject.size).to eq 3 }
      it { is_expected.to include 'first' => 'http://test.host/index.json?page=1'  }
      it { is_expected.to include 'next'  => 'http://test.host/index.json?page=2'  }
      it { is_expected.to include 'last'  => 'http://test.host/index.json?page=14' }
    end
  end

  describe 'headers' do
    subject { response.headers.to_h }

    it { is_expected.to include 'X-Total-Pages' => '14' }
    it { is_expected.to include 'X-Total-Count' => '676' }
    it { is_expected.to include 'X-Per-Page' => '50' }
    it { is_expected.to include 'X-Current-Page' => '1' }

    context 'when method is HEAD' do
      let(:method) { :head }

      it { is_expected.to include 'X-Total-Pages' => '14' }
      it { is_expected.to include 'X-Total-Count' => '676' }
      it { is_expected.to include 'X-Per-Page' => '50' }
      it { is_expected.to include 'X-Current-Page' => '1' }
    end
  end
end
