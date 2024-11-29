cask "caido" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.44.0"
  sha256 arm:   "c65d7ca9eb02aad0e0bebb931802d7720eea6898a14e11c87adbe9c7887780c6",
         intel: "eac48465f154d3460e70f26e67360b6cebe849ad7dc0f9b6394efe3734698239"

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