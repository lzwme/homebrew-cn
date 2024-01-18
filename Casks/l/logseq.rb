cask "logseq" do
  arch arm: "arm64", intel: "x64"

  version "0.10.4"
  sha256 arm:   "1e78f20e6fdf5ec79e3a6c8f2fa18f5c4df27b400958fc0e314caa4b41d9145e",
         intel: "c4efe8519e752c3d770c9e87a2f4d6a1e887131b7389557cb1096a7607d0060e"

  url "https:github.comlogseqlogseqreleasesdownload#{version}logseq-darwin-#{arch}-#{version}.dmg"
  name "Logseq"
  desc "Privacy-first, open-source platform for knowledge sharing and management"
  homepage "https:github.comlogseqlogseq"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Logseq.app"

  zap trash: [
    "~LibraryApplication SupportLogseq",
    "~LibraryLogsLogseq",
    "~LibraryPreferencescom.electron.logseq.plist",
    "~LibrarySaved Application Statecom.electron.logseq.savedState",
  ]
end