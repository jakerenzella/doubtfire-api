require 'test_helper'
require 'date'

class UnitsTest < ActiveSupport::TestCase
  include Rack::Test::Methods
  include TestHelpers::AuthHelper
  include TestHelpers::JsonHelper

  def app
    Rails.application
  end

  # Test POST for creating new unit
  def test_units_post
    data_to_post = add_auth_token(unit: {
                                    name: 'Intro to Social Skills',
                                    code: 'JRRW40003',
                                    start_date: '2016-05-14T00:00:00.000Z',
                                    end_date: '2017-05-14T00:00:00.000Z'
                                  })
    expected_unit = data_to_post[:unit]
    unit_count = Unit.all.length

    # The post that we will be testing.
    post_json '/api/units.json', data_to_post

    # Check to see if the unit's name matches what was expected
    unit_keys = %w(name code start_date end_date)
    assert_json_matches_model(last_response_body, data_to_post[:unit].as_json, unit_keys)

    assert_equal unit_count + 1, Unit.all.count
    assert_equal expected_unit[:name], Unit.last.name
  end
  # End POST tests
  # --------------------------------------------------------------------------- #

  # --------------------------------------------------------------------------- #
  # GET tests

  # Test GET for getting all units
  def test_units_get
    # The GET we are testing
    get with_auth_token '/api/units'

    actual_unit = last_response_body[0]
    expected_unit = Unit.first
    assert_equal expected_unit.name, actual_unit['name']
    assert_equal expected_unit.code, actual_unit['code']
    assert_equal expected_unit.start_date.to_date, actual_unit['start_date'].to_date
    assert_equal expected_unit.end_date.to_date, actual_unit['end_date'].to_date.to_date

    # Check last unit in Units (created in seed.db)
    actual_unit = last_response_body[1]
    expected_unit = Unit.find(2)

    assert_equal expected_unit.name, actual_unit['name']
    assert_equal expected_unit.code, actual_unit['code']
    assert_equal expected_unit.start_date.to_date, actual_unit['start_date'].to_date
    assert_equal expected_unit.end_date.to_date, actual_unit['end_date'].to_date.to_date
  end

  # Test GET for getting a specific unit by id
  def test_units_get_by_id
    # Test getting the first unit with id of 1
    get with_auth_token '/api/units/1'

    actual_unit = last_response_body
    expected_unit = Unit.find(1)

    # Check to see if the first unit's match
    assert_equal actual_unit['name'], expected_unit.name
    assert_equal actual_unit['code'], expected_unit.code
    assert_equal actual_unit['start_date'].to_date, expected_unit.start_date.to_date
    assert_equal actual_unit['end_date'].to_date, expected_unit.end_date.to_date

    # Get response back from getting a unit by id
    # Test getting the first unit with id of 2
    get with_auth_token '/api/units/2'

    actual_unit = last_response_body
    expected_unit = Unit.find(2)

    # Check to see if the first unit's match
    assert_equal actual_unit['name'], expected_unit.name
    assert_equal actual_unit['code'], expected_unit.code
    assert_equal actual_unit['start_date'].to_date, expected_unit.start_date.to_date
    assert_equal actual_unit['end_date'].to_date, expected_unit.end_date.to_date
  end
  # End GET tests
  # --------------------------------------------------------------------------- #
end
