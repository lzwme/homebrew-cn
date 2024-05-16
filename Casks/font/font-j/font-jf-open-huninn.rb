cask "font-jf-open-huninn" do
  version "2.0"
  sha256 "eec8b0b68c34b9166ae37bed839b6126116b225d97f21a5954bb542b9fd1e68c"

  url "https:github.comjustfontopen-huninn-fontreleasesdownloadv#{version}jf-openhuninn-#{version}.ttf",
      verified: "github.comjustfontopen-huninn-font"
  name "jf open huninn"
  name "jf open 粉圓"
  homepage "https:justfont.comhuninn"

  font "jf-openhuninn-#{version}.ttf"

  # No zap stanza required
end