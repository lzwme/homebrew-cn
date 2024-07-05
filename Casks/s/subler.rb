cask "subler" do
  version "1.8.1"
  sha256 "605579d55ffc943bfd4e965bc18e79070feb4b1b1ec9f26c2cd704f04daa796b"

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