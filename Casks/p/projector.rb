cask "projector" do
  arch arm: "arm64", intel: "x64"
  archapp = on_arch_conditional arm: "-arm"

  version "1.1.0"
  sha256 arm:   "a2f51be000977500a0b1e08a6f357495c98600f542d5cd9cdd8e88cc3785679a",
         intel: "a509d7fe44ffdfbb6fb81058172558b47591ac5ac25376782574cf99be58397b"

  url "https:github.comJetBrainsprojector-clientreleasesdownloadlauncher-v#{version}projector-darwin-signed-#{arch}-launcher-v#{version}.zip",
      verified: "github.comJetBrainsprojector-client"
  name "JetBrains Projector"
  desc "Common and client-related code for running Swing applications remotely"
  homepage "https:lp.jetbrains.comprojector"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :high_sierra"

  app "projector#{archapp}.app"

  zap trash: [
    "~LibraryApplication Supportprojector-launcher",
    "~LibraryPreferencescom.electron.projector.plist",
    "~LibrarySaved Application Statecom.electron.projector.savedState",
  ]
end