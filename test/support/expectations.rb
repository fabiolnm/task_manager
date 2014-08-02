module Minitest::Expectations
  infect_an_assertion :assert_validates_presence_of, :must_validate_presence_of, :reverse
  infect_an_assertion :assert_validates_inclusion_of, :must_validate_inclusion_of, :reverse
end
