cask "font-bizter" do
  version "0.0.2"
  sha256 "288b32b8a8d01892f358e468cd95991a6a203d57c2fdbe1ba4bb0a58f740b455"

  url "https:github.comyuru7BIZTERreleasesdownloadv#{version}BIZTER_v#{version}.zip"
  name "BIZTER"
  homepage "https:github.comyuru7BIZTER"

  no_autobump! because: :requires_manual_review

  font "BIZTER_v#{version}BIZTER-Bold.ttf"
  font "BIZTER_v#{version}BIZTER-Regular.ttf"

  # No zap stanza required
end