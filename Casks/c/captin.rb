cask "captin" do
  version "1.3.1"
  sha256 :no_check

  url "https:raw.githubusercontent.comcool8jaypublicmastercaptinCaptin.zip",
      verified: "raw.githubusercontent.comcool8jaypublicmastercaptin"
  name "Captin"
  desc "Tool to show caps lock status"
  homepage "https:captin.mystrikingly.com"

  livecheck do
    url "https:raw.githubusercontent.comcool8jaypublicmastercaptinappcast.xml"
    strategy :sparkle, &:short_version
  end

  app "Captin.app"

  uninstall quit: "com.100hps.captin"

  zap trash: [
    "~LibraryCachescom.100hps.captin",
    "~LibraryPreferencescom.100hps.captin.plist",
  ]
end