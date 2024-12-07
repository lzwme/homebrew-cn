cask "font-sudo" do
  version "2.1"
  sha256 "4d7d108cb41dc9a8edf8b6912a192ff56dc810f058f76f499d2a732ea59e7223"

  url "https:github.comjenskutileksudo-fontreleasesdownloadv#{version}sudo.zip"
  name "Sudo"
  homepage "https:github.comjenskutileksudo-font"

  font "sudoSudoUIVariable.ttf"
  font "sudoSudoVariable.ttf"

  # No zap stanza required
end