module UniversityCountry
  # To add a new country with universities, just add in the enum the country
  # and add the directory location of this country to the LOCATION_HASH

  # Country enum
  ENGLAND = 1

  # Hash mapping country to folder where can be found
  LOCATION_HASH = {
    ENGLAND => "lib/university_mail/universities_england/*.txt"
  }

  private_constant :LOCATION_HASH

  def get_universities_path(university_country)

    if LOCATION_HASH.has_key?(university_country)
      LOCATION_HASH[university_country]
    else
      raise "No university country found"
    end
  end

end
