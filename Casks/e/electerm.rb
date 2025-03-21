cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.72.48"
  sha256 arm:   "567df8aac2813be9a47f8d0eb3b26ca9076c9ffe3d75ac0bcc666e4e0ad93896",
         intel: "dfd22996aeb6dca13076d3ebe72be292736c6317bfd12a64c7edbf4cf969d09a"

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