cask "arduino-ide" do
  arch arm: "ARM64", intel: "64bit"

  version "2.3.4"
  sha256 arm:   "bc3baaf66c5ac386c9bc7963796396b894fbeddb851e7eee75dabebc83c5c633",
         intel: "ba8e522090f29d6715f78137fcab4c5857fbadd63f4376a26ec4661a6e5fc0e2"

  url "https:github.comarduinoarduino-idereleasesdownload#{version}arduino-ide_#{version}_macOS_#{arch}.dmg",
      verified: "github.comarduinoarduino-ide"
  name "Arduino IDE"
  desc "Electronics prototyping platform"
  homepage "https:www.arduino.ccensoftware"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "arduino-ide@nightly"
  depends_on macos: ">= :catalina"

  app "Arduino IDE.app"

  zap trash: [
    "~.arduinoIDE",
    "~LibraryApplication Supportarduino-ide",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscc.arduino.ide*.sfl*",
    "~LibraryPreferencescc.arduino.IDE*.plist",
    "~LibrarySaved Application Statecc.arduino.IDE#{version.major}.savedState",
  ]
end