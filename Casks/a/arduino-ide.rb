cask "arduino-ide" do
  arch arm: "ARM64", intel: "64bit"

  version "2.3.6"
  sha256 arm:   "18dbf23f7f87133a8c139b14df8a647f12fd97b5f612344688f7150255a9391f",
         intel: "ddbab78ebad1f617c0d8a05efed83b4da2ff208534031e125824ff924df1e189"

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