cask "font-sudo" do
  version "0.80"
  sha256 "6b1d090b1fa304ba78ac0025b7a3fb373fed9d4b5e2ea12717ea8de00865a6e5"

  url "https:github.comjenskutileksudo-fontreleasesdownloadv#{version}sudo.zip"
  name "Sudo"
  desc "Font for programmers and command-line users"
  homepage "https:github.comjenskutileksudo-font"

  font "sudoSudoVariable.ttf"

  # No zap stanza required
end