cask "katalon-studio" do
  arch arm: "%20Arm64"

  version "10.2.1"
  sha256 arm:   "b4e5accceea974c8499389d625b6b26bae14a8e46c4c269e6eed3064b814bd1b",
         intel: "c7925576b19e65f0134f4169f03c434b5daa5c5181864ef09c1658fa3bfdd484"

  url "https:download.katalon.comfree#{version}releaseKatalon%20Studio#{arch}.dmg"
  name "Katalon Studio"
  desc "Test automation solution"
  homepage "https:katalon.comdownload"

  livecheck do
    url "https:github.comkatalon-studiokatalon-studio"
    regex(^free[._-]v?(\d+(?:\.\d+)+)$i)
  end

  app "Katalon Studio.app"

  zap trash: [
    "~.katalon",
    "~LibraryPreferencescom.kms.katalon.product.product.plist",
    "~LibrarySaved Application Statecom.kms.katalon.product.product.savedState",
  ]
end