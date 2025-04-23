cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.80.2"
  sha256 arm:   "a5594f0ff4997d11356972350350a53a1399effdd6f869b997a34caf519ffbfd",
         intel: "3d4f25b9efa8182275d8a02cce547a4a53e0714051bf686d95f366152a88a024"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:github.comelectermelecterm"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end