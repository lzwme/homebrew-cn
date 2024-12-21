cask "font-elstobd" do
  version "3.000"
  sha256 "f926bd4bb160276827f6c6e682fe5b41cd7c7a90ea800ed1a776d6d3176f3699"

  url "https:github.compsb1558Elstob-fontreleasesdownloadv#{version}Elstob_#{version}.zip"
  name "ElstobD"
  homepage "https:github.compsb1558Elstob-font"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Elstob_fontvariableElstob-Italic.ttf"
  font "Elstob_fontvariableElstob.ttf"

  # No zap stanza required
end