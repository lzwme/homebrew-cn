cask "font-sudo" do
  version "1.0"
  sha256 "e95efe89a6e5627f9eb875c91eb22e80e704a20ad2725894c3169655a4bff57e"

  url "https:github.comjenskutileksudo-fontreleasesdownloadv#{version}sudo.zip"
  name "Sudo"
  desc "Font for programmers and command-line users"
  homepage "https:github.comjenskutileksudo-font"

  font "sudoSudoVariable.ttf"

  # No zap stanza required
end