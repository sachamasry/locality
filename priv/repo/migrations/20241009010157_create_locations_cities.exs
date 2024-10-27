defmodule Klepsidra.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:locations_cities,
             primary_key: false,
             comment:
               "All cities with a population > 500 or seats of adm div down to PPLA4 (ca 185.000), see 'geoname' table for columns. This data comes from the [GeoNames project](https://geonames.org/), from the `cities500.zip` file"
           ) do
      add(:id, :uuid,
        primary_key: true,
        null: false,
        comment: "UUID-based city primary key"
      )

      add(:geoname_id, :integer,
        null: false,
        comment: "Integer id of record in geonames database"
      )

      add(:name, :string,
        null: false,
        default: "",
        comment: "Name of geographical point (utf8) varchar(200)"
      )

      add(:ascii_name, :string,
        null: true,
        default: "",
        comment: "Name of geographical point in plain ascii characters, varchar(200)"
      )

      add(:alternate_names, :string,
        null: true,
        default: "",
        comment:
          "Alternate_names, comma separated, ascii names automatically transliterated, convenience attribute from alternatename table, varchar(10000)"
      )

      add(:latitude, :float,
        null: false,
        comment: "Latitude in decimal degrees (wgs84)"
      )

      add(:longitude, :float,
        null: false,
        comment: "Longitude in decimal degrees (wgs84)"
      )

      add(
        :feature_class,
        references(:locations_feature_classes,
          column: :feature_class,
          type: :binary_id,
          on_delete: :nothing,
          on_update: :nothing
        ),
        null: false,
        comment:
          "Class of geographic feature. See http://www.geonames.org/export/codes.html, char(1)"
      )

      add(
        :feature_code,
        references(:locations_feature_codes,
          column: :feature_code,
          type: :binary_id,
          on_delete: :nothing,
          on_update: :nothing
        ),
        null: false,
        comment:
          "Foreign key to `locations_feature_codes`. See http://www.geonames.org/export/codes.html, varchar(10)"
      )

      add(
        :country_code,
        references(:locations_countries,
          column: :iso_country_code,
          type: :binary_id,
          on_delete: :nothing,
          on_update: :nothing
        ),
        null: false,
        comment:
          "Foreign key to `locations_countries`. ISO-3166 2-letter country code, 2 characters"
      )

      add(:cc2, :string,
        null: true,
        default: "",
        comment:
          "Alternate country codes, comma separated, ISO-3166 2-letter country code, 200 characters"
      )

      add(
        :administrative_division_1_code,
        references(:locations_administrative_divisions_1,
          column: :administrative_division_1_code,
          type: :binary_id,
          on_delete: :nothing,
          on_update: :nothing
        ),
        null: true,
        default: nil,
        comment:
          "Fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code; varchar(20)"
      )

      add(
        :administrative_division_2_code,
        :string,
        # references(:locations_administrative_divisions_2,
        #   column: :administrative_division_2_code,
        #   type: :binary_id,
        #   on_delete: :nothing,
        #   on_update: :nothing
        # ),
        null: true,
        default: nil,
        comment:
          "Code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80)"
      )

      add(:administrative_division_3_code, :string,
        null: true,
        default: nil,
        comment: "Code for third level administrative division, varchar(20)"
      )

      add(:administrative_division_4_code, :string,
        null: true,
        default: nil,
        comment: "Code for fourth level administrative division, varchar(20)"
      )

      add(:population, :integer,
        null: false,
        default: nil,
        comment: "Bigint (8 byte int)"
      )

      add(:elevation, :integer,
        null: true,
        default: nil,
        comment: "In meters, integer"
      )

      add(:dem, :integer,
        null: true,
        default: nil,
        comment:
          "Digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat."
      )

      add(:timezone, :string,
        null: false,
        comment: "The iana timezone id (see file timeZone.txt) varchar(40)"
      )

      add(:modification_date, :date,
        null: false,
        comment: "Date of last modification in yyyy-MM-dd format"
      )

      timestamps()
    end

    create(
      unique_index(:locations_cities, [:geoname_id],
        comment: "Unique index on GeoNames' primary key, `geonames_id``"
      )
    )

    create(
      index(:locations_cities, [:name, :country_code],
        comment: "Index on city name and country code"
      )
    )

    create(
      index(:locations_cities, [:latitude, :longitude],
        comment: "Index on city's latitude and longitude, for geospatial searches"
      )
    )

    create(
      index(:locations_cities, [:name, :feature_code, :population, :country_code],
        comment:
          "Index on city name, feature code, population and country code. Useful for sorting cities in order of importance and population"
      )
    )

    create(
      index(:locations_cities, [:administrative_division_1_code],
        comment: "Index on administrative division level 1 code"
      )
    )

    create(
      index(:locations_cities, [:administrative_division_2_code],
        comment: "Index on administrative division level 2 code"
      )
    )

    create(
      index(:locations_cities, [:country_code],
        comment: "Index on ISO-3166 2-letter country code"
      )
    )

    create(index(:locations_cities, [:timezone], comment: "Index on timezone string"))
  end
end
