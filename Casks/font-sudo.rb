cask "font-sudo" do
  version "1.2"
  sha256 "161a8d81f882063fe54302c3fe0b2ce9bfc14065b6e1457278595826c41d6dc3"

  url "https:github.comjenskutileksudo-fontreleasesdownloadv#{version}sudo.zip"
  name "Sudo"
  desc "Font for programmers and command-line users"
  homepage "https:github.comjenskutileksudo-font"

  font "sudoSudoVariable.ttf"

  # No zap stanza required
end