require "test_helper"

describe Task do
  it { must_validate_presence_of :task_list   }
  it { must_validate_presence_of :description }
end
