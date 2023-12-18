cask "katalon-studio" do
  version "8.6.8"
  sha256 "a35b6e9b806ffcf564026da2e40f328ba1af54d74a0a9b45bc6e3a114b2b255a"

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