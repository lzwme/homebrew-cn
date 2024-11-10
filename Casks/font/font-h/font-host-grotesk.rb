cask "font-host-grotesk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhostgrotesk"
  name "Host Grotesk"
  homepage "https:fonts.google.comspecimenHost+Grotesk"

  font "HostGrotesk-Italic[wght].ttf"
  font "HostGrotesk[wght].ttf"

  # No zap stanza required
end