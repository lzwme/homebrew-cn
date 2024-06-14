cask "font-monocraft-nerd-font" do
  version "3.0"
  sha256 "431329f14c1c4635b248d1d6a0d797dac5fdb5e678fad0858fe0c6e356b3b17c"

  url "https:github.comIdreesIncMonocraftreleasesdownloadv#{version}Monocraft-nerd-fonts-patched.ttf"
  name "Monocraft with Nerd glyphs"
  homepage "https:github.comIdreesIncMonocraft"

  font "Monocraft-nerd-fonts-patched.ttf"

  # No zap stanza required
end