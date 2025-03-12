cask "subler" do
  version "1.8.6"
  sha256 "a2926c02aff10d4d51b33084ce4eb88c12a8ade0f7d8bb50778d2946d0ff84ce"

  url "https:github.comSublerAppSublerreleasesdownload#{version}Subler-#{version}.zip",
      verified: "github.comSublerAppSubler"
  name "Subler"
  desc "Mux and tag mp4 files"
  homepage "https:subler.org"

  livecheck do
    url "https:subler.orgappcastappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Subler.app"

  zap trash: [
    "~LibraryApplication SupportSubler",
    "~LibraryCachesorg.galad.Subler",
    "~LibraryPreferencesorg.galad.Subler.plist",
    "~LibrarySaved Application Stateorg.galad.Subler.savedState",
  ]
end