require 'minitest/autorun'
require 'json'
require_relative './utils'


class Level3Test < Minitest::Test
  def test_output
    Utils.import_data
    output_content = Utils.build_output
    expected_content = JSON.parse(File.read('./data/expected_output.json'))

    assert_equal output_content['rentals'][0], expected_content['rentals'][0], "Rental objects should have the same keys/values pairs"
    assert_equal output_content['rentals'][1], expected_content['rentals'][1], "Rental objects should have the same keys/values pairs"
    assert_equal output_content['rentals'][2], expected_content['rentals'][2], "Rental objects should have the same keys/values pairs"
  end

end