cask "trilium-notes" do
  version "0.62.4"
  sha256 "cac03c4ed497c4e91336dc1e0f115dfdf66f984c3c3f887aa730e97fc6efd818"

  url "https:github.comzadamtriliumreleasesdownloadv#{version}trilium-mac-x64-#{version}.zip"
  name "Trilium Notes"
  desc "Personal knowledge base"
  homepage "https:github.comzadamtrilium"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "trilium-mac-x64Trilium Notes.app"

  zap trash: [
    "~LibraryApplication SupportTrilium Notes",
    "~LibraryApplication Supporttrilium-data",
    "~LibraryPreferencescom.electron.trilium-notes.plist",
    "~LibrarySaved Application Statecom.electron.trilium-notes.savedState",
  ]
end