cask "mks" do
  version "1.7"
  sha256 "5e99acc34113b6974d799a4442682d3b82efc7096fc9a3fef78dc471975d68e8"

  url "https:github.comx0054MKSreleasesdownload#{version}MKS.zip"
  name "MKS"
  desc "Mechanical keyboard simulator"
  homepage "https:github.comx0054MKS"

  app "MKS.app"

  caveats do
    requires_rosetta
  end
end