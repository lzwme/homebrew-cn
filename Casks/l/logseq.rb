cask "logseq" do
  arch arm: "arm64", intel: "x64"

  version "0.10.2"
  sha256 arm:   "015166cc2dcaabf6477eb363c9d474a6b4134bf2fcc478cddda40f02d86c04e4",
         intel: "c9890a559e4385b578b5fabf9f911f9e4b86bdc97d87c5fe06e84f9235063b31"

  url "https:github.comlogseqlogseqreleasesdownload#{version}logseq-darwin-#{arch}-#{version}.dmg"
  name "Logseq"
  desc "Privacy-first, open-source platform for knowledge sharing and management"
  homepage "https:github.comlogseqlogseq"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Logseq.app"

  zap trash: [
    "~LibraryApplication SupportLogseq",
    "~LibraryLogsLogseq",
    "~LibraryPreferencescom.electron.logseq.plist",
    "~LibrarySaved Application Statecom.electron.logseq.savedState",
  ]
end