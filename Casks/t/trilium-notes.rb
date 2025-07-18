cask "trilium-notes" do
  version "0.63.7"
  sha256 "c110cd7d6fdcdfec9d833937f09e611af967786e3fa838673d6274a7268b0b22"

  url "https://ghfast.top/https://github.com/zadam/trilium/releases/download/v#{version}/trilium-mac-x64-#{version}.zip"
  name "Trilium Notes"
  desc "Personal knowledge base"
  homepage "https://github.com/zadam/trilium"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-04-05", because: :unmaintained, replacement_cask: "triliumnext-notes"

  depends_on macos: ">= :high_sierra"

  app "trilium-mac-x64/Trilium Notes.app"

  zap trash: [
    "~/Library/Application Support/Trilium Notes",
    "~/Library/Application Support/trilium-data",
    "~/Library/Preferences/com.electron.trilium-notes.plist",
    "~/Library/Saved Application State/com.electron.trilium-notes.savedState",
  ]

  caveats do
    requires_rosetta
  end
end