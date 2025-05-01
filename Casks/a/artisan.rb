cask "artisan" do
  version "3.1.2"
  sha256 "9842f65d1304583c95484b74fc28da40cf5f5c5260e4e2a78b78fb1537ee86e8"

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