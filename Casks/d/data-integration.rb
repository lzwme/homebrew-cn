cask "data-integration" do
  version "9.4.0.0-343"
  sha256 "e6804fae1a9aa66b92e781e9b2e835d72d56a6adc53dc03e429a847991a334e8"

  url "https://privatefilesbucket-community-edition.s3.amazonaws.com/#{version}/ce/client-tools/pdi-ce-#{version}.zip",
      verified: "privatefilesbucket-community-edition.s3.amazonaws.com/"
  name "Pentaho Data Integration"
  desc "End to end data integration and analytics platform"
  homepage "https://pentaho.com/products/pentaho-data-integration/"

  livecheck do
    url "https://privatefilesbucket-community-edition.s3.amazonaws.com/"
    regex(/pdi-ce[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
    strategy :xml do |xml, regex|
      xml.get_elements("//Contents/Key").map do |item|
        match = item.text&.strip&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  app "data-integration/Data Integration.app"

  caveats do
    requires_rosetta
  end
end