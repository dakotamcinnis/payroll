require "test_helper"

class PayPeriodTest < ActiveSupport::TestCase
  setup do
    @start = Time.new(2023, 01, 03).to_date
    @end = Time.new(2023, 01, 16).to_date
    @call = Time.new(2023, 01, 17).to_date
  end

  # New

  test "For new pay_period, no default start" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.new()
    end

    assert pay_period
    assert_nil pay_period.start
  end


  test "For new pay_period, no default end" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.new()
    end

    assert pay_period
    assert_nil pay_period.end
  end


  test "For new pay_period, no default call" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.new()
    end

    assert pay_period
    assert_nil pay_period.call
  end

  test "For new pay_period, active by default" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.new()
    end

    assert pay_period
    assert_equal true, pay_period.active
  end

  # Create

  test "Create pay_period successfully" do
    pay_period = nil

    assert_difference "PayPeriod.count", 1 do
      pay_period = PayPeriod.create(
        start: @start, end: @end, call: @call
      )
    end

    assert pay_period
    assert_equal true, pay_period.active
    assert_equal @start, pay_period.start
    assert_equal @end, pay_period.end
    assert_equal @call, pay_period.call
  end

  test "Create inactive pay_period successfully" do
    pay_period = nil

    assert_difference "PayPeriod.count", 1 do
      pay_period = PayPeriod.create(
        active: false, start: @start, end: @end, call: @call
      )
    end

    assert pay_period
    assert_equal false, pay_period.active
    assert_equal @start, pay_period.start
    assert_equal @end, pay_period.end
    assert_equal @call, pay_period.call
  end

  test "No creation or save if no start" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.create(
        call: @call, end: @end
      )
    end

    assert_no_difference "PayPeriod.count" do
      pay_period.save
    end
  end

  test "No creation or save if no end" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.create(
        start: @start, call: @call
      )
    end

    assert_no_difference "PayPeriod.count" do
      pay_period.save
    end
  end

  test "No creation or save if no call" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.create(
        start: @start, end: @end
      )
    end

    assert_no_difference "PayPeriod.count" do
      pay_period.save
    end
  end

  test "No creation or save if end before start" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.create(
        start: @end, end: @start, call: @call
      )
    end

    assert_no_difference "PayPeriod.count" do
      pay_period.save
    end
  end

  test "No creation or save if end is start" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.create(
        start: @start, end: @start, call: @call
      )
    end

    assert_no_difference "PayPeriod.count" do
      pay_period.save
    end
  end

  test "No creation or save if call before end" do
    pay_period = nil

    assert_no_difference "PayPeriod.count" do
      pay_period = PayPeriod.create(
        start: @start, end: @call, call: @end
      )
    end

    assert_no_difference "PayPeriod.count" do
      pay_period.save
    end
  end

  test "Creation if call is end" do
    pay_period = nil

    assert_difference "PayPeriod.count", 1 do
      pay_period = PayPeriod.create(
        start: @start, end: @end, call: @end
      )
    end

    assert pay_period
    assert_equal @start, pay_period.start
    assert_equal @end, pay_period.end
    assert_equal @end, pay_period.call
  end

  # Update

  test "Successful update" do
    pay_period = pay_periods(:jan17active)
    new_call = @call

    PayPeriod.update(call: new_call)

    updated_pay_period = PayPeriod.find(pay_period.id)
    assert_equal new_call, updated_pay_period.call
  end

  test "No update if no start" do
    pay_period = pay_periods(:jan17active)
    new_start = nil
    new_end = @end

    PayPeriod.update(start: new_start, end: new_end)

    updated_pay_period = PayPeriod.find(pay_period.id)
    assert_not_equal new_start, updated_pay_period.start
    assert_not_equal new_end, updated_pay_period.end
  end

  test "No update if no end" do
    pay_period = pay_periods(:jan17active)
    new_start = @start
    new_end = nil

    PayPeriod.update(start: new_start, end: new_end)

    updated_pay_period = PayPeriod.find(pay_period.id)
    assert_not_equal new_start, updated_pay_period.start
    assert_not_equal new_end, updated_pay_period.end
  end

  test "No update if no call" do
    pay_period = pay_periods(:jan17active)
    new_start = @start
    new_call = nil

    PayPeriod.update(start: new_start, call: new_call)

    updated_pay_period = PayPeriod.find(pay_period.id)
    assert_not_equal new_start, updated_pay_period.start
    assert_not_equal new_call, updated_pay_period.call
  end

  test "No update if end before start" do
    pay_period = pay_periods(:jan17active)
    new_start = @end
    new_end = @start
    new_call = @call

    PayPeriod.update(start: new_start, end: new_end, call: new_call)

    updated_pay_period = PayPeriod.find(pay_period.id)
    assert_not_equal new_start, updated_pay_period.start
    assert_not_equal new_end, updated_pay_period.end
    assert_not_equal new_call, updated_pay_period.call
  end

  test "No update if end is start" do
    pay_period = pay_periods(:jan17active)
    new_start = @end
    new_end = @end
    new_call = @call

    PayPeriod.update(start: new_start, end: new_end, call: new_call)

    updated_pay_period = PayPeriod.find(pay_period.id)
    assert_not_equal new_start, updated_pay_period.start
    assert_not_equal new_end, updated_pay_period.end
    assert_not_equal new_call, updated_pay_period.call
  end

  test "No update if call before end" do
    pay_period = pay_periods(:jan17active)
    new_start = @start
    new_end = @call
    new_call = @end

    PayPeriod.update(start: new_start, end: new_end, call: new_call)

    updated_pay_period = PayPeriod.find(pay_period.id)
    assert_not_equal new_start, updated_pay_period.start
    assert_not_equal new_end, updated_pay_period.end
    assert_not_equal new_call, updated_pay_period.call
  end

  test "Update when call is end" do
    pay_period = pay_periods(:jan17active)
    new_start = @start
    new_end = @end
    new_call = @end

    PayPeriod.update(start: new_start, end: new_end, call: new_call)

    updated_pay_period = PayPeriod.find(pay_period.id)
    assert_equal new_start, updated_pay_period.start
    assert_equal new_end, updated_pay_period.end
    assert_equal new_call, updated_pay_period.call
  end

  # Destroy

  test "Destroy successfully" do
    pay_period = pay_periods(:jan17active)

    assert PayPeriod.exists?(pay_period.id)

    assert_difference "PayPeriod.count", -1 do
      pay_period.destroy
    end

    refute PayPeriod.exists?(pay_period.id)
  end

  # TODO: Add timesheet dependent destroy test

  # Other

  test "Correct display name" do
    pay_period = pay_periods(:jan17active)

    assert_equal "#2: Mon. Jan. 17, '22 - Sun. Jan. 30, '22", pay_period.display_name
  end

  test "Correct display dates" do
    pay_period = pay_periods(:jan17active)

    assert_equal "Mon. Jan. 17, '22 - Sun. Jan. 30, '22", pay_period.display_dates
  end

  # TODO: Add other timesheet tests
end
