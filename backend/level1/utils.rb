# The main module for utility functionalities
require 'json'
require 'date'

module Utils
  @@data = nil
  @@cars_list = Hash.new
  @@rentals_list = Hash.new


  # Class for cars
  class Car

    attr_accessor :id, :price_per_day, :price_per_km

    def initialize(params)
      @id = params['id']
      @price_per_day = params['price_per_day']
      @price_per_km = params['price_per_km']
    end

  end

  # Class for rentals
  class Rental
    attr_accessor :id, :car_id, :start_date, :end_date, :distance
  
    def initialize(params)
      @id = params['id']
      @car_id = params['car_id']
      @start_date = params['start_date']
      @end_date = params['end_date']
      @distance = params['distance']
    end
  
    def fetch_car
      Utils.cars_list[car_id.to_s]
    end
  
    # Compute the duration of the rental
    def duration
      Integer(Date.parse(end_date) - Date.parse(start_date)) + 1
    end
  
    # Compute the price related to the duration of the rental
    def duration_price
      duration * fetch_car.price_per_day
    end
  
    # Compute the price related to the distance of the rental
    def distance_price
      distance * fetch_car.price_per_km
    end
  
    # Compute the price of the rental
    def price
      duration_price + distance_price
    end

    def as_json
      {'id' => self.id, 'price' => self.price}
    end
  
  end

  
  # Load the data (cars and rentals) from the JSON file
  def self.import_data
    json_file = File.read('./data/input.json')
    @@data = JSON.parse(json_file)

    @@data['cars'].each do |car|
      @@cars_list[car['id'].to_s] = Car.new(car)
    end

    @@data['rentals'].each do |rental|
      @@rentals_list[rental['id'].to_s] = Rental.new(rental)
    end

  end

  # Return the parsed data from the JSON file
  def self.data
    @@data
  end

  # Return the list of cars
  def self.cars_list
    @@cars_list
  end

  # Return the list of rentals
  def self.rentals_list
    @@rentals_list
  end

  # Generate the output content
  def self.build_output
    output = {'rentals' => []}

    self.rentals_list.each do |k_, rental|
      output['rentals'] << rental.as_json
    end

    output
  end

  # Save the ouput into a file on the disk
  def self.save_to_file
    output_content = self.build_output

    File.open("./data/output.json","w") do |f|
      f.write(JSON.pretty_generate(output_content))
    end
  end

end