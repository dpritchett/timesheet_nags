require 'test_helper'

class NaggerTest < Minitest::Test
  def setup
    @nagger = TimesheetNags::Nagger.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::TimesheetNags::VERSION
  end

  def test_it_gets_timesheets
    result = @nagger.latest_timesheets
  end

  def test_latest_timestamp_is_int
    assert @nagger.latest_timestamp_age.is_a?(Integer)
    assert @nagger.latest_timestamp_age > -1
  end

  def test_it_sends_a_nag
    @nagger.send_nag
  end

  def test_it_checks_and_nags
    @nagger.check_and_nag
  end
end
