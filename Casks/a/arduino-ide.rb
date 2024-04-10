cask "arduino-ide" do
  arch arm: "ARM64", intel: "64bit"

  version "2.3.2"
  sha256 arm:   "e682a29610569e421fc8d8276ff3c785347ca8521bfe4817baefa7f542237a1d",
         intel: "6e78e3830798388ee77429fac1ba7b5eb0643a57e51b44a9b10ffe221f054839"

  url "https:github.comarduinoarduino-idereleasesdownload#{version}arduino-ide_#{version}_macOS_#{arch}.dmg",
      verified: "github.comarduinoarduino-ide"
  name "Arduino IDE"
  desc "Electronics prototyping platform"
  homepage "https:www.arduino.ccensoftware"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "arduino-ide-nightly"
  depends_on macos: ">= :high_sierra"

  app "Arduino IDE.app"

  zap trash: [
    "~.arduinoIDE",
    "~LibraryApplication Supportarduino-ide",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscc.arduino.ide*.sfl*",
    "~LibraryPreferencescc.arduino.IDE*.plist",
    "~LibrarySaved Application Statecc.arduino.IDE#{version.major}.savedState",
  ]
end