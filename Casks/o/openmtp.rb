cask "openmtp" do
  arch arm: "arm64", intel: "x64"

  version "3.2.24"
  sha256 arm:   "7a2873a5b69167c63d269da12552c26fb274a3591407c0a21c14becdc18b69a3",
         intel: "0e57129e94f9c893e26951669162d41cd346e7d8e452bfd390fcb4f648396679"

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