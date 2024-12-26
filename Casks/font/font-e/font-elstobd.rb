cask "font-elstobd" do
  version "3.001"
  sha256 "622a0117e5eabe5e179dac673c8b8027f75a1d7f082a4a248038374091356eb8"

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