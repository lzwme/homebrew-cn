cask "paseo" do
  arch arm: "arm64", intel: "x64"

  version "0.1.64"
  sha256 arm:   "b7d7aa4f1b9c568b390ebcc4fd9477a4ece86b1215d493969cfe704c6271ea4b",
         intel: "4acdbdd0788bc0f4d14220a9442572ebd01fccc619c5786467a8ff0b2aac3f5b"

  url "https://ghfast.top/https://github.com/getpaseo/paseo/releases/download/v#{version}/Paseo-#{version}-#{arch}.dmg",
      verified: "github.com/getpaseo/paseo/"
  name "Paseo"
  desc "Self-hosted daemon for AI coding agents"
  homepage "https://paseo.sh/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on macos: ">= :monterey"

  app "Paseo.app"
  binary "#{appdir}/Paseo.app/Contents/Resources/bin/paseo"

  zap trash: [
    "~/Library/Application Support/dev.paseo.desktop",
    "~/Library/Caches/dev.paseo.desktop",
    "~/Library/Logs/dev.paseo.desktop",
    "~/Library/Preferences/dev.paseo.desktop.plist",
    "~/Library/Saved Application State/dev.paseo.desktop.savedState",
    "~/Library/WebKit/dev.paseo.desktop",
  ]
end