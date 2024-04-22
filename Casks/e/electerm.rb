cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.70"
  sha256 arm:   "8fc97a467ca53cb05f6055f4f7f3d05113d73fbc93d91395d5d5f30e99a4dc7a",
         intel: "ca4b09c105c957ad8e011a998dc3cd35c82a832d1203e3b9061632722f264edc"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:github.comelectermelecterm"

  auto_updates true

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end