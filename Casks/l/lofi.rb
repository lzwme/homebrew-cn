cask "lofi" do
  version "2.0.2"
  sha256 "a954c06e72c0076c20186f86161287147f815153cb22311fe2e3e39bfbc676fe"

  url "https:github.comdvxlofireleasesdownloadv#{version}lofi.dmg",
      verified: "github.comdvxlofi"
  name "Lofi"
  desc "Spotify player with WebGL visualisations"
  homepage "https:www.lofi.rocks"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "lofi.app"

  zap trash: [
    "~LibraryApplication Supportlofi",
    "~LibraryPreferenceslofi.rocks.plist",
    "~LibrarySaved Application Statelofi.rocks.savedState",
  ]

  caveats do
    requires_rosetta
  end
end