require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  def setup
    @user = users(:confirmed_user)
    @activity = @user.activities.build(date: Time.zone.now, duration: 1)
  end

  test "should be valid" do
    assert @activity.valid?
  end

  test "should have date" do
    @activity.date = nil
    assert_not @activity.valid?
  end

  test "duration should be positive" do
    @activity.duration = -1
    assert_not @activity.valid?

    @activity.duration = 0
    assert_not @activity.valid?
  end

  test "distance should be positive" do
    @activity.distance = -1
    assert_not @activity.valid?    
  end
  
  test "should have distance or duration" do
    @activity.distance = nil
    @activity.duration = nil

    assert_not @activity.valid?
  end

  test "should have unit if distance is set" do
    @activity.distance = 1
    @activity.unit = nil

    assert_not @activity.valid?
  end

  test "should calculate calculated_pace" do
    @activity.distance = 10
    @activity.unit = :miles
    @activity.duration = 3600
    @activity.save

    assert_equal 360, @activity.reload.calculated_pace

    @activity.distance = 10
    @activity.unit = :kilometers
    @activity.duration = 1800
    @activity.save
    converted_distance = @activity.distance * 0.6213712
    pace = @activity.duration / converted_distance

    assert_equal pace, @activity.reload.calculated_pace

    @activity.distance = 800
    @activity.unit = :meters
    @activity.duration = 120
    @activity.save
    converted_distance = @activity.distance * 0.0006213711985
    pace = @activity.duration / converted_distance

    assert_equal pace, @activity.reload.calculated_pace 
    
    @activity.distance = 600
    @activity.unit = :yards
    @activity.duration = 90
    @activity.save
    converted_distance = @activity.distance * 0.0005681818239083977
    pace = @activity.duration / converted_distance

    assert_equal pace, @activity.reload.calculated_pace     
  end

end