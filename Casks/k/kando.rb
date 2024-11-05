cask "kando" do
  arch arm: "arm64", intel: "x64"

  version "1.5.1"
  sha256 arm:   "57d4166ab5ef35ac7995a55d6581c6f6bf1243200bcfa4103d00a51237ecdb12",
         intel: "f59b30a3fa4f82c8b1b1f618f9cdac3ab1157bfcda951e3d41ea224562e9f028"

  url "https:github.comkando-menukandoreleasesdownloadv#{version}Kando-#{version}-#{arch}.dmg"
  name "Kando"
  desc "Pie Menu"
  homepage "https:github.comkando-menukando"

  depends_on macos: ">= :catalina"

  app "Kando.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.kando.sfl*",
    "~LibraryApplication SupportKando",
    "~LibraryPreferencescom.electron.kando.plist",
  ]
end