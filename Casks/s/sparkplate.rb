cask "sparkplate" do
  version "1.0.0"
  sha256 "f9bff9256c4c95bf1a53b9c074e6a3f44d35e75043a404f306c1bd09121e93e7"

  url "https:github.comGreenfireInchomebrew-sparkplatereleasesdownloadv#{version}Sparkplate.zip"
  name "Sparkplate"
  desc "Features a test page for resolving human readable domains to crypto addresses"
  homepage "https:github.comGreenfireIncSparkplate.Vue"

  depends_on macos: ">= :high_sierra"

  app "Sparkplate.app"

  zap trash: [
    "~LibraryApplication Supportsparkplate",
    "~LibraryPreferencescom.sparkplate.app.plist",
    "~LibraryPreferencesio.greenfire.sparkplate-.plist",
    "~LibraryPreferencesio.greenfire.sparkplate.helper.plist",
    "~LibraryPreferencesio.greenfire.sparkplate.plist",
    "~LibrarySaved Application Statecom.sparkplate.app.savedState",
    "~LibrarySaved Application Stateio.greenfire.sparkplate.savedState",
  ]
end