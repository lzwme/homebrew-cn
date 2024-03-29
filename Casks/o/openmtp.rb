cask "openmtp" do
  arch arm: "arm64", intel: "x64"

  version "3.2.10"
  sha256 arm:   "8440e9c956342b876722bbb5c0ea3fcdbbbbbb78edda7d788c579319aceacb76",
         intel: "5c0f3f687f392c1329a63c868c01f6e526a72dcecf59bf8d07b70a426c3929f5"

  url "https:github.comganeshrvelopenmtpreleasesdownloadv#{version}openmtp-#{version}-mac-#{arch}.zip",
      verified: "github.comganeshrvelopenmtp"
  name "OpenMTP"
  desc "Android file transfer"
  homepage "https:openmtp.ganeshrvel.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "OpenMTP.app"

  zap trash: [
    "~.io.ganeshrvel",
    "~LibraryApplication Supportio.ganeshrvel.openmtp",
    "~LibraryApplication SupportOpenMTP",
    "~LibraryPreferencesio.ganeshrvel.openmtp.plist",
  ]
end