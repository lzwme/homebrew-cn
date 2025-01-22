cask "katalon-studio" do
  arch arm: "%20Arm64"

  version "10.1.0"
  sha256 arm:   "ee39cb0452c97518a8ee5e0d0156a39a0882fad92acc70b65ad34a40e25cef93",
         intel: "5da9f402fd4e009ff13f62ded16dfc8ad67d8c4e2a244dc6095be013847eb553"

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