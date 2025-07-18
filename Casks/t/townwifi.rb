cask "townwifi" do
  version "1.0.4,21"
  sha256 "4e0907ba00b6b83e90840deb6b259044a2068b4a4d1d360bdde02118f4b2ae26"

  url "https://storage.googleapis.com/townwifi-downloads/mac/update/TownWifi_UD_#{version.csv.second}.dmg",
      verified: "storage.googleapis.com/townwifi-downloads/"
  name "TownWiFi"
  homepage "https://townwifi.jp/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-03", because: :unmaintained

  auto_updates true

  app "TownWifi.app"

  caveats do
    requires_rosetta
  end
end