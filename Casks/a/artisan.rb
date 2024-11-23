cask "artisan" do
  version "3.1.0"
  sha256 "b132eac7faf50b61458cd49fc5637aadb158277f58b97403c7b5e06a721782e7"

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