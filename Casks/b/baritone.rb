cask "baritone" do
  version "1.0.9"
  sha256 "dc8eff4202b78e7bf0405b26223cb6e1892257a76af40581cc64f775ab2ca253"

  url "https:github.comtma02baritonereleasesdownloadv#{version}Baritone-macOS.zip",
      verified: "github.comtma02baritone"
  name "Baritone"
  desc "Spotify controls that live in the menu bar"
  homepage "https:tma02.github.iobaritone"

  app "Baritone-darwin-x64Baritone.app"
end