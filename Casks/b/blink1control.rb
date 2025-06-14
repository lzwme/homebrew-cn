cask "blink1control" do
  # NOTE: "1" is not a version number, but an intrinsic part of the product name
  arch arm: "arm64", intel: "x64"

  version "2.2.9"
  sha256 arm:   "5201cc77aa1b51b927d90e59f6221ff55f147f5910f6e75b6acd0966b3f4c099",
         intel: "fa4a8457f905b6e7ef288c621fed646305ac31408932a9cfa7181fde41499ec2"

  url "https:github.comtodbotBlink1Control2releasesdownloadv#{version}Blink1Control#{version.major}-#{version}-mac-#{arch}.dmg",
      verified: "github.comtodbotBlink1Control2"
  name "Blink1Control"
  desc "Utility to control blink(1) USB RGB LED devices"
  homepage "https:blink1.thingm.com"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :el_capitan"

  app "Blink1Control#{version.major}.app"

  zap trash: [
    "~LibraryApplication SupportBlink1Control#{version.major}",
    "~LibraryLogsBlink1Control#{version.major}",
    "~LibraryPreferencescom.thingm.blink1control#{version.major}.plist",
    "~LibrarySaved Application Statecom.thingm.blink1control#{version.major}.savedState",
  ]
end