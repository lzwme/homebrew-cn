cask "enigma-game" do
  version "1.30"
  sha256 "a15a17b9399da9bc5cfdb085765de448a18a372340676e8d3d3913765e147e19"

  url "https://ghfast.top/https://github.com/Enigma-Game/Enigma/releases/download/#{version}/Enigma-#{version}.dmg",
      verified: "github.com/Enigma-Game/"
  name "Enigma"
  desc "Puzzle game inspired by Oxyd and Rock'n'Roll"
  homepage "https://www.nongnu.org/enigma/"

  no_autobump! because: :requires_manual_review

  suite "Enigma"

  zap trash: [
    "~/.enigmarc.xml",
    "~/Library/Application Support/Enigma",
  ]
end