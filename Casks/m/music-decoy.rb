cask "music-decoy" do
  version "1.0"
  sha256 "e4fa4670e24522ac5e0999ed6c483201d257e858fc644d3490edee6887b847eb"

  url "https:github.comFuzzyIdeasMusicDecoyreleasesdownloadv#{version}MusicDecoy.zip",
      verified: "github.comFuzzyIdeasMusicDecoy"
  name "Music Decoy"
  desc "Music app blocker utility"
  homepage "https:lowtechguys.commusicdecoy"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Music Decoy.app"

  # No zap stanza required
end