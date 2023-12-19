cask "mellowplayer" do
  version "3.4.0"
  sha256 "0d7801211951de5ca3d3e8ce4c301bc2b3e29c18bdd90ec0a763f26b2bb1bafc"

  url "https:github.comColinDuquesnoyMellowPlayerreleasesdownload#{version}MellowPlayer.dmg",
      verified: "github.comColinDuquesnoyMellowPlayer"
  name "MellowPlayer"
  desc "Moved to gitlab"
  homepage "https:colinduquesnoy.github.ioMellowPlayer"

  deprecate! date: "2023-12-17", because: :discontinued

  app "MellowPlayer.app"

  zap trash: [
    "~LibraryApplication SupportMellowPlayer",
    "~LibraryCachesMellowPlayer",
    "~LibraryPreferencescom.mellowplayer.3.plist",
    "~LibraryPreferencescom.mellowplayer.mellowplayer.MellowPlayer.plist",
  ]
end