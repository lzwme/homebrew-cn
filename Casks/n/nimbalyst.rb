cask "nimbalyst" do
  arch arm: "arm64", intel: "x64"

  version "0.58.4"
  sha256 arm:   "78a477db54d634578fede1691f722e31fd46b61a11804c76068cf5f52db0097d",
         intel: "20017b176ee763c780bd68d64d608cb59fa3da5deaf46f1b17e62c082f0ea92e"

  url "https://ghfast.top/https://github.com/Nimbalyst/nimbalyst/releases/download/v#{version}/Nimbalyst-macOS-#{arch}.dmg",
      verified: "github.com/Nimbalyst/nimbalyst/"
  name "Nimbalyst"
  desc "Visual workspace for building with Codex and Claude Code"
  homepage "https://nimbalyst.com/"

  depends_on macos: ">= :monterey"

  app "Nimbalyst.app"

  zap trash: "~/Library/Application Support/@nimbalyst"
end