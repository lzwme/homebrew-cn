cask "applite" do
  version "1.2.2"
  sha256 "4ea45aae9b188ca54b4b7771da3507c1f57f37e135e66e8f28f23819f3467e8c"

  url "https:github.commilanvaradyApplitereleasesdownloadv#{version}Applite.dmg",
      verified: "github.commilanvaradyApplite"
  name "Applite"
  desc "User-friendly GUI app for Homebrew"
  homepage "https:aerolite.devapplite"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"
  depends_on formula: "pinentry-mac"

  app "Applite.app"

  zap trash: [
    "~LibraryApplication SupportApplite",
    "~LibraryApplication Supportdev.aerolite.Applite",
    "~LibraryCachesApplite",
    "~LibraryCachesdev.aerolite.Applite",
    "~LibraryContainersdev.aerolite.Applite",
    "~LibraryHTTPStoragesdev.aerolite.Applite",
    "~LibraryPreferencesdev.aerolite.Applite.plist",
    "~LibrarySaved Application Statedev.aerolite.Applite.savedState",
  ]
end