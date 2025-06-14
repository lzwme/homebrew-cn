cask "deskreen" do
  version "2.0.4"
  sha256 "43b9a49d0ff70211a88cfd23bf660dac9f3609063dde3ccf6d07f5307050e443"

  url "https:github.compavlobudeskreenreleasesdownloadv#{version}Deskreen-#{version}.dmg",
      verified: "github.compavlobudeskreen"
  name "Deskreen"
  desc "Turns any device with a web browser into a secondary screen"
  homepage "https:deskreen.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Deskreen.app"

  zap trash: [
    "~LibraryApplication SupportDeskreen",
    "~LibraryLogsDeskreen",
    "~LibraryPreferencescom.pavlobu.Deskreen.plist",
    "~LibrarySaved Application Statecom.pavlobu.Deskreen.savedState",
  ]

  caveats do
    requires_rosetta
  end
end