cask "trilium-notes" do
  arch arm: "arm64", intel: "x64"

  version "0.98.1"
  sha256 arm:   "5b257bcb6b58e5a183554b886158051fef09ec456c2e58f8b7b43142b14a179b",
         intel: "9fc8a132aaf682011068045ecb13bf8f38e129caaa1bf25d1873ed39be94f034"

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