cask "kando" do
  arch arm: "arm64", intel: "x64"

  version "1.6.0"
  sha256 arm:   "33c8137a66650ce53b0f2a6bb68fa3a95de9ff627e0c43b2f4ba2b420d85c918",
         intel: "6910eacb592230e9d8cd1c57f02fb9e06d06074400760c4bdeee3097b0f81a4f"

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