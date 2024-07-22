cask "subler" do
  version "1.8.4"
  sha256 "849d56bc14a030e8dfb194b299c5a962b9bd31539436677fed66a77ffa946f2b"

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