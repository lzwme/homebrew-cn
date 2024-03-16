cask "katalon-studio" do
  version "8.6.9"
  sha256 "e6e485784e02158acfffe9793c28b539785ef11f281cc40ca568626b2572a459"

  url "https:download.katalon.com#{version}Katalon%20Studio.dmg"
  name "Katalon Studio"
  desc "Test automation solution"
  homepage "https:www.katalon.comdownload"

  livecheck do
    url "https:github.comkatalon-studiokatalon-studio"
    strategy :github_latest
  end

  app "Katalon Studio.app"

  zap trash: [
    "~.katalon",
    "~LibraryPreferencescom.kms.katalon.product.product.plist",
    "~LibrarySaved Application Statecom.kms.katalon.product.product.savedState",
  ]
end