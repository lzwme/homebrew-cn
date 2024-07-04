cask "subler" do
  version "1.8"
  sha256 "6744081d6d1015795638efcf0630e663e964a0cd1f6b4eed940cfde940ae88f1"

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

  app "Subler.app"

  zap trash: [
    "~LibraryApplication SupportSubler",
    "~LibraryCachesorg.galad.Subler",
    "~LibraryPreferencesorg.galad.Subler.plist",
    "~LibrarySaved Application Stateorg.galad.Subler.savedState",
  ]
end