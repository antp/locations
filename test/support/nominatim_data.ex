defmodule Locations.Support.NominatimData do
  @moduledoc """
  This module contains responses from Nominatim that are used for testing
  """

  def missing_features() do
    %{
      "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
      "type" => "FeatureCollection"
    }
  end

  def no_features() do
    %{
      "features" => [],
      "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
      "type" => "FeatureCollection"
    }
  end

  def has_features_1() do
    %{
      "features" => [
        %{
          "bbox" => [-0.8943214, 51.7903516, -0.8939829, 51.7905312],
          "geometry" => %{
            "coordinates" => [-0.894139715767561, 51.7904389],
            "type" => "Point"
          },
          "properties" => %{
            "address" => %{
              "city" => "Aylesbury Vale",
              "community_centre" => "Dinton Village Hall",
              "country" => "United Kingdom",
              "country_code" => "gb",
              "county" => "Bucks",
              "postcode" => "HP17 8UQ",
              "road" => "Upton Road",
              "state" => "England",
              "state_district" => "South East",
              "suburb" => "Dinton-with-Ford and Upton"
            },
            "category" => "amenity",
            "display_name" =>
              "Dinton Village Hall, Upton Road, Dinton-with-Ford and Upton, Aylesbury Vale, Bucks, South East, England, HP17 8UQ, United Kingdom",
            "importance" => 0.901,
            "osm_id" => 602_254_458,
            "osm_type" => "way",
            "place_id" => 196_416_146,
            "place_rank" => 30,
            "type" => "community_centre"
          },
          "type" => "Feature"
        }
      ],
      "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
      "type" => "FeatureCollection"
    }
  end

  def has_features_2() do
    %{
      "features" => [
        %{
          "bbox" => [10.778539, 59.911488, 10.778639, 59.911588],
          "geometry" => %{
            "coordinates" => [10.778589, 59.911538],
            "type" => "Point"
          },
          "properties" => %{
            "address" => %{
              "city" => "Oslo",
              "city_district" => "Gamle Oslo",
              "country" => "Norge",
              "country_code" => "no",
              "county" => "Oslo",
              "house_number" => "20",
              "neighbourhood" => "Arctanderbyen",
              "postcode" => "0654",
              "road" => "Brinken",
              "suburb" => "Kampen",
              "supermarket" => "Coop Prix Kampen"
            },
            "category" => "shop",
            "display_name" =>
              "Coop Prix Kampen, 20, Brinken, Arctanderbyen, Kampen, Gamle Oslo, Oslo, 0654, Norge",
            "icon" =>
              "https://nominatim.openstreetmap.org/images/mapicons/shopping_supermarket.p.20.png",
            "importance" => 0.44100000000000006,
            "osm_id" => 1_486_026_488,
            "osm_type" => "node",
            "place_id" => 246_804_858,
            "place_rank" => 30,
            "type" => "supermarket"
          },
          "type" => "Feature"
        },
        %{
          "bbox" => [10.778792, 59.911329, 10.778892, 59.911429],
          "geometry" => %{
            "coordinates" => [10.778842, 59.911379],
            "type" => "Point"
          },
          "properties" => %{
            "address" => %{
              "city" => "Oslo",
              "city_district" => "Gamle Oslo",
              "country" => "Norge",
              "country_code" => "no",
              "county" => "Oslo",
              "house_number" => "20",
              "neighbourhood" => "Arctanderbyen",
              "postcode" => "0654",
              "road" => "Brinken",
              "suburb" => "Galgeberg"
            },
            "category" => "place",
            "display_name" =>
              "20, Brinken, Arctanderbyen, Galgeberg, Gamle Oslo, Oslo, 0654, Norge",
            "importance" => 0.44100000000000006,
            "osm_id" => 2_791_175_671,
            "osm_type" => "node",
            "place_id" => 32_849_750,
            "place_rank" => 30,
            "type" => "house"
          },
          "type" => "Feature"
        }
      ],
      "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
      "type" => "FeatureCollection"
    }
  end

  def get_nominatim_status_response(status) do
    %Mojito.Response{
      body:
        "{\"type\":\"FeatureCollection\",\"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\",\"features\":[]}",
      complete: true,
      headers: [
        {"date", "Sun, 27 Oct 2019 10:57:10 GMT"},
        {"server", "Apache/2.4.29 (Ubuntu)"},
        {"access-control-allow-origin", "*"},
        {"access-control-allow-methods", "OPTIONS,GET"},
        {"strict-transport-security", "max-age=31536000; includeSubDomains; preload"},
        {"expect-ct",
         "max-age=0, report-uri=\"https://openstreetmap.report-uri.com/r/d/ct/reportOnly\""},
        {"content-type", "application/json; charset=UTF-8"}
      ],
      status_code: status
    }
  end

  def get_nominatim_good_response() do
    %Mojito.Response{
      body:
        "{\"type\":\"FeatureCollection\",
        \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\",
        \"features\":[{\"type\":\"Feature\",\"properties\":{\"place_id\":196416146,\"osm_type\":\"way\",\"osm_id\":602254458,\"display_name\":\"Dinton Village Hall, Upton Road, Dinton-with-Ford and Upton, Aylesbury Vale, Bucks, South East, England, HP17 8UQ, United Kingdom\",\"place_rank\":30,\"category\":\"amenity\",\"type\":\"community_centre\",\"importance\":0.901,\"address\":{\"community_centre\":\"Dinton Village Hall\",\"road\":\"Upton Road\",\"suburb\":\"Dinton-with-Ford and Upton\",\"city\":\"Aylesbury Vale\",\"county\":\"Bucks\",\"state_district\":\"South East\",\"state\":\"England\",\"postcode\":\"HP17 8UQ\",\"country\":\"United Kingdom\",\"country_code\":\"gb\"}},\"bbox\":[-0.8943214,51.7903516,-0.8939829,51.7905312],\"geometry\":{\"type\":\"Point\",\"coordinates\":[-0.894139715767561,51.7904389]}}]}",
      complete: true,
      headers: [
        {"date", "Sun, 27 Oct 2019 10:57:10 GMT"},
        {"server", "Apache/2.4.29 (Ubuntu)"},
        {"access-control-allow-origin", "*"},
        {"access-control-allow-methods", "OPTIONS,GET"},
        {"strict-transport-security", "max-age=31536000; includeSubDomains; preload"},
        {"expect-ct",
         "max-age=0, report-uri=\"https://openstreetmap.report-uri.com/r/d/ct/reportOnly\""},
        {"content-type", "application/json; charset=UTF-8"}
      ],
      status_code: 200
    }
  end

  def get_nominatim_no_features() do
    %Mojito.Response{
      body: "{\"type\":\"FeatureCollection\",
        \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\",
        \"features\":[]}",
      complete: true,
      headers: [
        {"date", "Sun, 27 Oct 2019 10:57:10 GMT"},
        {"server", "Apache/2.4.29 (Ubuntu)"},
        {"access-control-allow-origin", "*"},
        {"access-control-allow-methods", "OPTIONS,GET"},
        {"strict-transport-security", "max-age=31536000; includeSubDomains; preload"},
        {"expect-ct",
         "max-age=0, report-uri=\"https://openstreetmap.report-uri.com/r/d/ct/reportOnly\""},
        {"content-type", "application/json; charset=UTF-8"}
      ],
      status_code: 200
    }
  end

  def get_nominatim_missing_features() do
    %Mojito.Response{
      body: "{\"type\":\"FeatureCollection\",
        \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\"}",
      complete: true,
      headers: [
        {"date", "Sun, 27 Oct 2019 10:57:10 GMT"},
        {"server", "Apache/2.4.29 (Ubuntu)"},
        {"access-control-allow-origin", "*"},
        {"access-control-allow-methods", "OPTIONS,GET"},
        {"strict-transport-security", "max-age=31536000; includeSubDomains; preload"},
        {"expect-ct",
         "max-age=0, report-uri=\"https://openstreetmap.report-uri.com/r/d/ct/reportOnly\""},
        {"content-type", "application/json; charset=UTF-8"}
      ],
      status_code: 200
    }
  end

  def get_nominatim_good_response_2() do
    %Mojito.Response{
      body: "{\"type\":\"FeatureCollection\",
        \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\",
        \"features\":[
          {\"type\":\"Feature\",\"properties\":{\"place_id\":196416146,\"osm_type\":\"way\",\"osm_id\":602254458,\"display_name\":\"Dinton Village Hall, Upton Road, Dinton-with-Ford and Upton, Aylesbury Vale, Bucks, South East, England, HP17 8UQ, United Kingdom\",\"place_rank\":30,\"category\":\"amenity\",\"type\":\"community_centre\",\"importance\":0.901,\"address\":{\"community_centre\":\"Dinton Village Hall\",\"road\":\"Upton Road\",\"suburb\":\"Dinton-with-Ford and Upton\",\"city\":\"Aylesbury Vale\",\"county\":\"Bucks\",\"state_district\":\"South East\",\"state\":\"England\",\"postcode\":\"HP17 8UQ\",\"country\":\"United Kingdom\",\"country_code\":\"gb\"}},\"bbox\":[-0.8943214,51.7903516,-0.8939829,51.7905312],\"geometry\":{\"type\":\"Point\",\"coordinates\":[-0.894139715767561,51.7904389]}},
          {\"type\":\"Feature\",\"properties\":{\"place_id\":196416147,\"osm_type\":\"way\",\"osm_id\":602254459,\"display_name\":\"Another Hall, Upton Road, Dinton-with-Ford and Upton, Aylesbury Vale, Bucks, South East, England, HP17 8UQ, United Kingdom\",\"place_rank\":30,\"category\":\"amenity\",\"type\":\"community_centre\",\"importance\":0.901,\"address\":{\"community_centre\":\"Dinton Village Hall\",\"road\":\"Upton Road\",\"suburb\":\"Dinton-with-Ford and Upton\",\"city\":\"Aylesbury Vale\",\"county\":\"Bucks\",\"state_district\":\"South East\",\"state\":\"England\",\"postcode\":\"HP17 8UQ\",\"country\":\"United Kingdom\",\"country_code\":\"gb\"}},\"bbox\":[-0.8943214,51.7903516,-0.8939829,51.7905312],\"geometry\":{\"type\":\"Point\",\"coordinates\":[-0.994139715767561,61.7904389]}}
          ]}",
      complete: true,
      headers: [
        {"date", "Sun, 27 Oct 2019 10:57:10 GMT"},
        {"server", "Apache/2.4.29 (Ubuntu)"},
        {"access-control-allow-origin", "*"},
        {"access-control-allow-methods", "OPTIONS,GET"},
        {"strict-transport-security", "max-age=31536000; includeSubDomains; preload"},
        {"expect-ct",
         "max-age=0, report-uri=\"https://openstreetmap.report-uri.com/r/d/ct/reportOnly\""},
        {"content-type", "application/json; charset=UTF-8"}
      ],
      status_code: 200
    }
  end

  def get_transport_error(msg, nil) do
    %Mojito.Error{message: msg, reason: nil}
  end

  def get_transport_error(nil, reason) do
    %Mojito.Error{message: nil, reason: %Mint.TransportError{reason: reason}}
  end
end
