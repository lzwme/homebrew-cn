cask "mos" do
  version "4.0.0,20260220.1"
  sha256 "c717bf8e8115a0daf607e7bde7a7f8b07816a175b916c3a8f6134afc8c18a9c4"

  url "https://ghfast.top/https://github.com/Caldis/Mos/releases/download/#{version.csv.first}/Mos.Versions.#{version.csv.first}#{"-#{version.csv.second}" if version.csv.second}.zip",
      verified: "github.com/Caldis/Mos/"
  name "Mos"
  desc "Smooths scrolling and set mouse scroll directions independently"
  homepage "https://mos.caldis.me/"

  livecheck do
    url "https://mos.caldis.me/appcast.xml"
    strategy :sparkle
  end

  conflicts_with cask: "mos@beta"

  app "Mos.app"

  zap trash: "~/Library/Preferences/com.caldis.Mos.plist"
end