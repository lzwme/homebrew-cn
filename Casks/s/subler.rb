cask "subler" do
  version "1.8.2"
  sha256 "d6fe18b770251e7c578452896ec796f4b8a5e16fe9847d87133002333c329571"

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