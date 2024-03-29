cask "logseq" do
  arch arm: "arm64", intel: "x64"

  version "0.10.8"
  sha256 arm:   "281ae8f0cde55f687b898236944f820609828e154d4e530a19003e15d1df90e4",
         intel: "79d2833aec056944144888d374a426e7f87df235a8528009f53da383bf04ef3d"

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