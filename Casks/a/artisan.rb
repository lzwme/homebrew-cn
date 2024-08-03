cask "artisan" do
  version "3.0.0"
  sha256 "1f33373964d1a468e8b201a76bfc8d923a3d6e7f6fb7eb6375d04b11a984d71e"

  url "https:github.comartisan-roaster-scopeartisanreleasesdownloadv#{version}artisan-mac-#{version}.dmg",
      verified: "github.comartisan-roaster-scopeartisan"
  name "Artisan"
  desc "Visual scope for coffee roasters"
  homepage "https:artisan-scope.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Artisan.app"

  zap trash: [
    "~LibraryApplication Supportartisan-scope",
    "~LibraryPreferencesorg.artisan-scope.Artisan.plist",
    "~LibrarySaved Application Stateorg.artisan-scope.artisan.savedState",
  ]
end