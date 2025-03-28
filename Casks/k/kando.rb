cask "kando" do
  arch arm: "arm64", intel: "x64"

  version "1.8.0"
  sha256 arm:   "0934aa51275cbe0508f6f4abb1e779d1357967c20c3ad3fca4105c66ff950a18",
         intel: "83de85aaf258c09c770957850c03284fffa7c9531ad9e388ced889aa7de51479"

  url "https:github.comkando-menukandoreleasesdownloadv#{version}Kando-#{version}-#{arch}.dmg",
      verified: "github.comkando-menukando"
  name "Kando"
  desc "Pie menu"
  homepage "https:kando.menu"

  depends_on macos: ">= :catalina"

  app "Kando.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.kando.sfl*",
    "~LibraryApplication SupportKando",
    "~LibraryPreferencescom.electron.kando.plist",
  ]
end