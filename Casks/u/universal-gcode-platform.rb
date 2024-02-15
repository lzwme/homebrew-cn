cask "universal-gcode-platform" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.5"
  sha256 arm:   "fe013f518a25a35e09928206e7d6f5a5a80a5f49cc24b645bf5b446fdd5deb95",
         intel: "025e7a75966c6ec81eb888023d6b7ca8199add2e26ff9f6bdf2c6ecc8d218c32"

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