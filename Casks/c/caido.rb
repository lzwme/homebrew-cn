cask "caido" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.42.0"
  sha256 arm:   "179e6ec7a315bdc4651644711e72ed3c6db6dd4ef07bec93d773cb049c1bd611",
         intel: "b370d7b656a8cda65917f8550423c37e5fbf48c86d160f86e19f926dfdb4a718"

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