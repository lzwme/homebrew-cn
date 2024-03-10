cask "universal-gcode-platform" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.6"
  sha256 arm:   "ac37e2152093f22afef864303cb260a7696a69323a6ca44a04c6ca7d5e3df2e6",
         intel: "2ae42047c1dec510aed900b1ce8de0eae7be8d6e49b0fe8a64d27b710cf0481b"

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