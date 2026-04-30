cask "nimbalyst" do
  arch arm: "arm64", intel: "x64"

  version "0.58.14"
  sha256 arm:   "4ee46174585a18719555e877d03788e202235ee14665320faf3babee9c2aa5f9",
         intel: "a690570d7d4c20ae107eed85d5f5605dbd1ffaf30b57535f2a361511bb8bde86"

  url "https://ghfast.top/https://github.com/Nimbalyst/nimbalyst/releases/download/v#{version}/Nimbalyst-macOS-#{arch}.dmg",
      verified: "github.com/Nimbalyst/nimbalyst/"
  name "Nimbalyst"
  desc "Visual workspace for building with Codex and Claude Code"
  homepage "https://nimbalyst.com/"

  depends_on macos: ">= :monterey"

  app "Nimbalyst.app"

  zap trash: "~/Library/Application Support/@nimbalyst"
end