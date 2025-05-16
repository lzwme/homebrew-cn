cask "artisan" do
  version "3.1.4"
  sha256 "d48f4d978a8eb7aae6d0076976b99a2ecd8a1ed8ec564e63eb01c748cab16f16"

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