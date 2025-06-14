cask "gyroflow" do
  version "1.6.1"
  sha256 "3c9ae9fbc8de95ea02e87891159711f98920d15014cc01bb03ff112226eb1627"

  url "https:github.comgyroflowgyroflowreleasesdownloadv#{version}Gyroflow-mac-universal.dmg",
      verified: "github.comgyroflowgyroflow"
  name "Gyroflow"
  desc "Video stabilization using gyroscope data"
  homepage "https:gyroflow.xyz"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Gyroflow.app"

  zap trash: "~LibraryCachesGyroflow"
end