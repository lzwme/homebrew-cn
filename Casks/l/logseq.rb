cask "logseq" do
  arch arm: "arm64", intel: "x64"

  version "0.10.1"
  sha256 arm:   "5fd0b9b59cabd93e06734cf9ce2bc428a210d25f7ebb052073eb3903e2cb6acf",
         intel: "8fd42af8a9b1a1527958abf9375298d375e5e6504d7514104e1da9cfdd014e95"

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