cask "yoda" do
  version "1.0.1"
  sha256 "4bed8d0f1e4a1be684fc4faf91bfd828f0f8cb6f7a3e4b60d28f0c4b1a94fdef"

  url "https:github.comwhoisandyyodareleasesdownloadv#{version}yoda-installer-#{version}.dmg"
  name "Yoda"
  desc "App to browse and download YouTube videos"
  homepage "https:github.comwhoisandyyoda"

  deprecate! date: "2024-09-01", because: :unmaintained

  app "Yoda.app"

  zap trash: [
    "~LibraryApplication Supportyoda",
    "~LibraryCachesyoda",
    "~LibraryPreferencescom.whoisandie.yoda.plist",
    "~LibrarySaved Application Statecom.whoisandie.yoda.savedState",
  ]

  caveats do
    requires_rosetta
  end
end