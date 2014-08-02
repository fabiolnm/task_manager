require "test_helper"

describe TaskList do
  it { must_validate_presence_of :name }
end
