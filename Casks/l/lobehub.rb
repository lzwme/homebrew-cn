cask "lobehub" do
  arch arm: "-arm64"

  version "1.88.9"
  sha256 arm:   "b3960bb8056443fb99dfc7da857b2cde2ae490b32ed15fba46345fd3acd30dbe",
         intel: "dd2b141247a8cb48ca213a2b2373c0522695f4a2c1c6886576204d5370c3a7d2"

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