cask "ultimaker-cura" do
  arch arm: "ARM64", intel: "X64"

  on_arm do
    version "5.7.1"
    sha256 "80465fbc2c50af1a64f68a7109a0b7beabbd18960c9d25213adcc39e0145f0cf"
  end
  on_intel do
    version "5.7.1"
    sha256 "6854689aa549e0aae07c002a401f024a57290b74ffae8ebe4fb234c2c0b8b48d"
  end

  url "https:github.comUltimakerCurareleasesdownload#{version}Ultimaker-Cura-#{version}-macos-#{arch}.dmg",
      verified: "github.comUltimakerCura"
  name "Ultimaker Cura"
  name "Cura"
  desc "3D printer and slicing GUI"
  homepage "https:ultimaker.comsoftwareultimaker-cura"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "UltiMaker Cura.app"

  uninstall quit: "nl.ultimaker.cura.dmg"

  zap trash: [
    "~.cura",
    "~LibraryApplication Supportcura",
    "~LibraryCachesUltimaker B.V.Ultimaker-Cura",
    "~LibraryLogscura",
    "~LibraryPreferencesnl.ultimaker.cura.dmg.plist",
    "~LibraryPreferencesnl.ultimaker.cura.plist",
    "~LibrarySaved Application Statenl.ultimaker.cura.dmg.savedState",
  ]
end