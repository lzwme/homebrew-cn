cask "clocker" do
  version "23.01"
  sha256 "6bd3f553fcd9e12dd656053305450aeb41912130b2f65d085718c9aa70cae0a8"

  url "https:github.comn0shakeClockerreleasesdownload#{version}Clocker.zip",
      verified: "github.comn0shakeClocker"
  name "Clocker"
  desc "Menu bar timezone tracker and compact calendar"
  homepage "https:abhishekbanthia.comclocker"

  depends_on macos: ">= :high_sierra"

  app "Clocker.app"

  uninstall launchctl: "com.abhishek.ClockerHelper",
            quit:      "com.abhishek.Clocker"

  zap trash: [
    "~LibraryApplication Scriptscom.abhishek.Clocker",
    "~LibraryContainerscom.abhishek.Clocker",
    "~LibraryPreferencescom.abhishek.Clocker.plist",
    "~LibraryPreferencescom.abhishek.ClockerHelper.plist",
    "~LibraryPreferencescom.abhishek.Clocker.prefs",
  ]
end