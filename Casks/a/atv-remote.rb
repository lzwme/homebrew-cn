cask "atv-remote" do
  arch arm: "-arm64"

  version "1.3.7"
  sha256 arm:   "9d38b971f15fcb4408cdfaea6e4c3c2885939f73b2fc0249aa6e9d15150bd10a",
         intel: "1956ca8b1092e08296813335f147573925331e0b2ed6b8cf7b72f80f58e7ff95"

  url "https:github.combsharperatv-desktop-remotereleasesdownloadv.#{version}ATV.Remote-#{version}#{arch}.dmg"
  name "ATV Remote"
  desc "Control Apple TV from your desktop"
  homepage "https:github.combsharperatv-desktop-remote"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "ATV Remote.app"

  zap trash: [
    "~LibraryApplication SupportATV Remote",
    "~LibraryPreferencescom.electron.atvDesktopRemote.plist",
    "~LibrarySaved Application Statecom.electron.atvDesktopRemote.savedState",
  ]
end