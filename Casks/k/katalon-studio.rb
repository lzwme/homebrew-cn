cask "katalon-studio" do
  arch arm: "%20Arm64"

  version "10.2.0"
  sha256 arm:   "56395ce0b04c6dc429c58c0c2e6dc3920cd62c1035a9ab18f39b03f81b9a05dd",
         intel: "bdf503b85e861523093d0fb4a3ace075a5c9349d62eb3b54f49205f54a9ef136"

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