cask "font-fira-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfiramono"
  name "Fira Mono"
  homepage "https:fonts.google.comspecimenFira+Mono"

  font "FiraMono-Bold.ttf"
  font "FiraMono-Medium.ttf"
  font "FiraMono-Regular.ttf"

  # No zap stanza required
end