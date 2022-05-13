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

  def test_commissions
    Utils.import_data
    expected_content = JSON.parse(File.read('./data/expected_output.json'))
    rental = Utils.rentals_list.fetch(1)
    rental.calculate_commission
    commission = rental.commission
    assert_equal commission.insurance_fee, expected_content['rentals'][0]['commission']['insurance_fee'], "Unexpected insurance fee"
    assert_equal commission.assistance_fee, expected_content['rentals'][0]['commission']['assistance_fee'], "Unexpected assistance_fee fee"
    assert_equal commission.drivy_fee, expected_content['rentals'][0]['commission']['drivy_fee'], "Unexpected Drivy fee"
  end

end