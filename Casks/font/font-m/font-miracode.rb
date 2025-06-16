cask "font-miracode" do
  version "1.0"
  sha256 "43efc3fd33e5a8eb7befda984bf745eda844777326e1ae06fb074707e1aeb66a"

  url "https:github.comIdreesIncMiracodereleasesdownloadv#{version}Miracode.ttf"
  name "Miracode"
  homepage "https:github.comIdreesIncMiracode"

  no_autobump! because: :requires_manual_review

  font "Miracode.ttf"

  # No zap stanza required
end