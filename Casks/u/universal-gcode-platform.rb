cask "universal-gcode-platform" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.8"
  sha256 arm:   "cabb7513888acd89520a9dd68d6508d7852a0ae3a5a77255b4a27962643f9f8c",
         intel: "2194055cd5b01f397f8781228c6e25ee73e2a7df3626625e898639bfa6c07b8b"

  url "https:github.comwinderUniversal-G-Code-Senderreleasesdownloadv#{version}macosx-#{arch}-ugs-platform-app-#{version}.dmg",
      verified: "github.comwinderUniversal-G-Code-Sender"
  name "Universal G-code Sender (Platform version)"
  desc "G-code sender for CNC (compatible with GRBL, TinyG, g2core and Smoothieware)"
  homepage "https:winder.github.iougs_website"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Universal Gcode Sender.app"

  zap trash: [
    "~LibraryApplication Supportugsplatform",
    "~LibraryPreferencesugs",
  ]

  caveats <<~EOS
    UGS developers do not sign their code and this app may need manual changes.
    For more information, see:
      https:github.comwinderUniversal-G-Code-Senderissues1351#issuecomment-579110056
  EOS
end