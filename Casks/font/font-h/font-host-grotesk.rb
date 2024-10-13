cask "font-host-grotesk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflhostgrotesk"
  name "Host Grotesk"
  homepage "https:github.comElement-TypeHostGrotesk"

  font "HostGrotesk-Italic[wght].ttf"
  font "HostGrotesk[wght].ttf"

  # No zap stanza required
end