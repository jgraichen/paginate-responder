module PaginateResponder
  module VERSION
    MAJOR = 1
    MINOR = 6
    PATCH = 0
    STAGE = :b0

    def self.to_s
      [MAJOR, MINOR, PATCH, STAGE].reject(&:nil?).join '.'
    end
  end
end
