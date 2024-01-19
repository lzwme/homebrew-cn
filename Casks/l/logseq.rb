cask "logseq" do
  arch arm: "arm64", intel: "x64"

  version "0.10.5"
  sha256 arm:   "141f234a8fa9dd2a63d24e2a420a155bc8b5692b3f5f018cff64a3c4088b4d16",
         intel: "6a5f249b1926ae3932c6cf67b4fb46bbf05fd633f3e9e996d4b31b1d689861e7"

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