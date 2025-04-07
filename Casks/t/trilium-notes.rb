cask "trilium-notes" do
  version "0.63.7"
  sha256 "c110cd7d6fdcdfec9d833937f09e611af967786e3fa838673d6274a7268b0b22"

  url "https:github.comzadamtriliumreleasesdownloadv#{version}trilium-mac-x64-#{version}.zip"
  name "Trilium Notes"
  desc "Personal knowledge base"
  homepage "https:github.comzadamtrilium"

  deprecate! date: "2025-04-05", because: :unmaintained, replacement: "triliumnext-notes"

  depends_on macos: ">= :high_sierra"

  app "trilium-mac-x64Trilium Notes.app"

  zap trash: [
    "~LibraryApplication SupportTrilium Notes",
    "~LibraryApplication Supporttrilium-data",
    "~LibraryPreferencescom.electron.trilium-notes.plist",
    "~LibrarySaved Application Statecom.electron.trilium-notes.savedState",
  ]

  caveats do
    requires_rosetta
  end
end