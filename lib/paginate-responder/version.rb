module PaginateResponder
  module VERSION
    MAJOR = 1
    MINOR = 3
    PATCH = 1
    STAGE = nil

    def self.to_s
      [MAJOR, MINOR, PATCH, STAGE].reject(&:nil?).join '.'
    end
  end
end
