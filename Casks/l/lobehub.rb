cask "lobehub" do
  arch arm: "-arm64"

  version "1.88.6"
  sha256 arm:   "04a9c4af3f90746724255a8ce324350a3f46d01716e04fcc1da241b451d2e298",
         intel: "ca030ab0ad3de6321a116e2603b37c71ff1697cbd702b676b98454a7ee989e71"

  url "https:github.comlobehublobe-chatreleasesdownloadv#{version}LobeHub-Beta-#{version}#{arch}-mac.zip"
  name "LobeHub"
  desc "AI chat framework"
  homepage "https:github.comlobehublobe-chat"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "LobeHub-Beta.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.lobehub.lobehub-desktop-beta.sfl*",
    "~LibraryApplication SupportLobeHub-Beta",
    "~LibraryLogsLobeHub-Beta",
    "~LibraryPreferencescom.lobehub.lobehub-desktop-beta.plist",
  ]
end