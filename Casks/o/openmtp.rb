cask "openmtp" do
  arch arm: "arm64", intel: "x64"

  version "3.2.23"
  sha256 arm:   "c35aa6ca2862ff5a8c0aea252b7117475f5700810491a34ff499031b1e909c78",
         intel: "1ead0e48a80d8baa5c242778f4adbb150f1242abfd788111d3a34bc0dd89e8ad"

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