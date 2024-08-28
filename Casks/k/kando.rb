cask "kando" do
  arch arm: "arm64", intel: "x64"

  version "1.3.0"
  sha256 arm:   "5fdd3aaa799367ffb743f717226d366f19635e9fc6b6b416e4f8ae87788c4776",
         intel: "05c8babc72d8252ee0a9b9bdb5d8ee8b4215015d49b6e7590ed4741b423d76f6"

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