cask "trilium-notes" do
  arch arm: "arm64", intel: "x64"

  version "0.97.1"
  sha256 arm:   "43c6f46b9a55ac5e9b03629d63e0eb16b98d11ff68d3b6bf6687e4a47e1c8ac7",
         intel: "58bd0c91815d2d3992122ace93eb72d099744c72e52092bf771878885728cee5"

  url "https://ghfast.top/https://github.com/TriliumNext/Trilium/releases/download/v#{version}/TriliumNotes-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/TriliumNext/Trilium/"
  name "TriliumNext Notes"
  desc "Hierarchical note taking application"
  homepage "https://triliumnext.github.io/Docs/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Trilium Notes.app"

  zap trash: [
    "~/Library/Application Support/trilium-data",
    "~/Library/Application Support/TriliumNext Notes",
    "~/Library/Preferences/com.electron.triliumnext-notes.plist",
    "~/Library/Saved Application State/com.electron.triliumnext-notes.savedState",
  ]
end