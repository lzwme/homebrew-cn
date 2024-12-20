cask "katalon-studio" do
  arch arm: "%20Arm64"

  version "10.0.1"
  sha256 arm:   "1095be7d7657b5b5967f4dc79786749af6d740689d10f5ce508a84fd5bd83c94",
         intel: "11f61d016996684be2907bb896850f6c6cb4beaaa55a95c055123b0cb38286ed"

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