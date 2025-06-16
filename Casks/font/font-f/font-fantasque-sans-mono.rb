cask "font-fantasque-sans-mono" do
  version "1.8.0"
  sha256 "84be689e231ff773ed9d352e83dccd8151d9e445f1cb0b88cb0e9330fc4d9cfc"

  url "https:github.combelluzjfantasque-sansreleasesdownloadv#{version}FantasqueSansMono-Normal.zip"
  name "Fantasque Sans Mono"
  homepage "https:github.combelluzjfantasque-sans"

  no_autobump! because: :requires_manual_review

  font "OTFFantasqueSansMono-Bold.otf"
  font "OTFFantasqueSansMono-BoldItalic.otf"
  font "OTFFantasqueSansMono-Italic.otf"
  font "OTFFantasqueSansMono-Regular.otf"

  # No zap stanza required
end