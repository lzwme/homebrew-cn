cask "caido" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.43.0"
  sha256 arm:   "387e6f0d68aeda629f4348c74f57ee06e9d5be3b041f524113b53c65878d29bc",
         intel: "b7fd61d70a777273982fa13105a39cef5f20ae06cd98b44f83c8bd924350bdc6"

  url "https:caido.downloadreleasesv#{version}caido-desktop-v#{version}-mac-#{arch}.dmg",
      verified: "caido.download"
  name "Caido"
  desc "Web security auditing toolkit"
  homepage "https:caido.io"

  livecheck do
    url "https:github.comcaidocaido"
  end

  depends_on macos: ">= :catalina"

  app "Caido.app"
  binary "#{appdir}Caido.appContentsResourcesbincaido-cli"

  zap trash: [
    "~LibraryApplication SupportCaido",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsio.caido.caido.sfl*",
    "~LibraryApplication Supportio.caido.Caido",
    "~LibraryPreferencesio.caido.Caido.plist",
    "~LibrarySaved Application Stateio.caido.Caido.savedState",
  ]
end