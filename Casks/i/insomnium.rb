cask "insomnium" do
  version "0.2.3-a"
  sha256 "3a561fa0d3413d23180d5488b0034a5bbcb2d433e4600e31d002e0ca2a52d9df"

  url "https:github.comArchGPTinsomniumreleasesdownloadcore%40#{version}Insomnium.Core-#{version}.signed.dmg"
  name "Insomnium"
  desc "HTTP and GraphQL Client"
  homepage "https:github.comArchGPTinsomnium"

  deprecate! date: "2024-07-28", because: :repo_archived

  depends_on macos: ">= :high_sierra"

  app "Insomnium.app"

  zap trash: [
    "~LibraryApplication SupportInsomnium",
    "~LibraryCachescom.insomnium.app",
    "~LibraryCachescom.insomnium.app.ShipIt",
    "~LibraryCookiescom.insomnium.app.binarycookies",
    "~LibraryPreferencesByHostcom.insomnium.app.ShipIt.*.plist",
    "~LibraryPreferencescom.insomnium.app.helper.plist",
    "~LibraryPreferencescom.insomnium.app.plist",
    "~LibrarySaved Application Statecom.insomnium.app.savedState",
  ]
end