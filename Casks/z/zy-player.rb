cask "zy-player" do
  version "2.8.8"
  sha256 "c00d2315d564f800fbb6d67fb3e3620276cfc0669737b20fdbc54d39b87596ab"

  url "https:github.comHunlongyuZY-Playerreleasesdownloadv#{version}ZY-Player-#{version}.dmg"
  name "ZY Player"
  desc "Video resource player"
  homepage "https:github.comHunlongyuZY-Player"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ZY Player.app"

  zap trash: [
    "~LibraryApplication Supportzy",
    "~LibraryPreferencescom.hunlongyu.zy.plist",
    "~LibrarySaved Application Statecom.hunlongyu.zy.savedState",
  ]

  caveats do
    requires_rosetta
  end
end