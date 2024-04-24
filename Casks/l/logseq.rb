cask "logseq" do
  arch arm: "arm64", intel: "x64"

  version "0.10.9"
  sha256 arm:   "64ec0b6b818ab2a449bfd0aae4494578ac2d251a0575e5ce24e78999451df4cd",
         intel: "a4560dfbff7f1b6142d6a1ed82db3f7fdd7626fb64e2d5c230c045245a1cfedf"

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