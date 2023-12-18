cask "font-elstobd" do
  version "2.103"
  sha256 "a3c1898db4f707079651c1409ae6010affb72510e0c695a2c83ffc2bfa063d52"

  url "https:github.compsb1558Elstob-fontreleasesdownloadv#{version}Elstob_#{version}.zip"
  name "ElstobD"
  desc "Variable font for medievalists"
  homepage "https:github.compsb1558Elstob-font"

  font "Elstob_fontvariableElstob-Italic.ttf"
  font "Elstob_fontvariableElstob.ttf"

  # No zap stanza required
end