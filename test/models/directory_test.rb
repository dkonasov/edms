require 'test_helper'

class DirectoryTest < ActiveSupport::TestCase
  test "Directory w/o displayName is invalid" do
    directory = Directory.new
    assert directory.invalid?
    assert directory.errors[:display_name].any?
  end
  test "Directory w/ displayName is valid" do
    directory = directories(:one)
    assert directory.valid?
  end
end
