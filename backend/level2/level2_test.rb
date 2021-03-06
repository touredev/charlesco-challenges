require 'minitest/autorun'
require 'json'
require_relative './utils'


class Level2Test < Minitest::Test
  def test_output
    Utils.import_data
    output_content = Utils.build_output
    expected_content = JSON.parse(File.read('./data/expected_output.json'))

    assert_equal output_content['rentals'][0], expected_content['rentals'][0], "Rental objects should have the same keys/values pairs"
    assert_equal output_content['rentals'][1], expected_content['rentals'][1], "Rental objects should have the same keys/values pairs"
    assert_equal output_content['rentals'][2], expected_content['rentals'][2], "Rental objects should have the same keys/values pairs"
  end

  def test_duration_price
    Utils.import_data
    expected_content = JSON.parse(File.read('./data/expected_output.json'))
    rental = Utils.rentals_list.fetch(1)
    assert_equal rental.duration_price, (expected_content['rentals'][0]['price'] - rental.distance_price), "Unexpected duration price"
  end

end