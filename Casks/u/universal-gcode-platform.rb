cask "universal-gcode-platform" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.3"
  sha256 arm:   "978557e8525a087a8f896e33f063b3cc46c573977a86b21b78292b0b71bca4fa",
         intel: "5349fc74dfb8cfdfe257c76eb8e4f0faf3729cea3fb7300155f8d62b0ed91753"

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