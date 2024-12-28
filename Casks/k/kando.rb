cask "kando" do
  arch arm: "arm64", intel: "x64"

  version "1.7.0"
  sha256 arm:   "c3304a17a51523d1517cbc4a6a523fc4e99b4648288f5fe0b57b13abbb00a2b0",
         intel: "4c6b27af16743aa530c443749408328a6158b8d55d6393207680fae1ca8e4cf4"

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