cask "caido" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.44.1"
  sha256 arm:   "b25991e47f00271eb3d67ac6c40c82d0a5b0bd473bfd0f288d027d8a09af0af6",
         intel: "fd69c0a209693d21dd079ff993c54b2542cf2ce612a7cceaf6611bf0e1f4ca2d"

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