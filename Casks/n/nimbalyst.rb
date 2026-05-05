cask "nimbalyst" do
  arch arm: "arm64", intel: "x64"

  version "0.58.21"
  sha256 arm:   "ad060b8ece8436d0773d90aa2a53f2f56291fe4b70d5321e5bf07e6876539134",
         intel: "8027a1c3094bd9353371780d3b8cb339f064c80a8c0f3c269a8dda5cd3137e1a"

  url "https://ghfast.top/https://github.com/Nimbalyst/nimbalyst/releases/download/v#{version}/Nimbalyst-macOS-#{arch}.dmg",
      verified: "github.com/Nimbalyst/nimbalyst/"
  name "Nimbalyst"
  desc "Visual workspace for building with Codex and Claude Code"
  homepage "https://nimbalyst.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Nimbalyst.app"

  zap trash: "~/Library/Application Support/@nimbalyst"
end