cask "pdfsam-basic" do
  arch arm: "arm64", intel: "x64"

  version "5.3.1"
  sha256 arm:   "a5dcf235d83bebc9d3247de2ff38156e02ccce10bb5cc1490c95dddec4f09fe9",
         intel: "7db089f0001a1312aeb2199e1d3cb783d664ba4ea68ec5749c5b97f7953a9504"

  url "https:github.comtorakikipdfsamreleasesdownloadv#{version}pdfsam-basic-#{version}-macos-#{arch}.dmg",
      verified: "github.comtorakikipdfsam"
  name "PDFsam Basic"
  desc "Extracts pages, splits, merges, mixes and rotates PDF files"
  homepage "https:pdfsam.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "PDFsam Basic.app"

  zap trash: [
    "~LibraryPreferencesorg.pdfsam.modules.plist",
    "~LibraryPreferencesorg.pdfsam.stage.plist",
    "~LibraryPreferencesorg.pdfsam.user.plist",
    "~LibrarySaved Application Stateorg.pdfsam.basic.savedState",
  ]
end