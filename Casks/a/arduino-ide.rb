cask "arduino-ide" do
  arch arm: "ARM64", intel: "64bit"

  version "2.3.1"
  sha256 arm:   "ee223847dcfdfafedfbe25042339659f3955fa909603c0dc824d072fcde1819a",
         intel: "3e1aee1212e0a94b1d8557711dc335ddc9bd2034678e319978a81d20a08b3d2e"

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
    "~LibrarySaved Application Statecc.arduino.IDE#{version.major}.savedState",
  ]
end