cask "universal-gcode-platform" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.14"
  sha256 arm:   "ab739ec61b3a5799e7ab07a0ce3b970bb0a1c3dab2ea3ee067f1ef27984e81d2",
         intel: "d92cf24c481a80ed89fe14129c084ea4235cb3d4e1ff00d7849ed765aa26ab08"

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