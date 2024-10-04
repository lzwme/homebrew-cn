cask "pocket-casts" do
  version "2.0.7"
  sha256 "db730fb3a6a3cdcca4c0491af22c76ba54050abc202ca655560fb7d34a51d0bd"

  url "https://cdn.a8c-ci.services/pocket-casts-desktop/pocket-casts-desktop-darwin-universal-v#{version}.dmg",
      verified: "cdn.a8c-ci.services/pocket-casts-desktop/"
  name "Pocket Casts"
  desc "Podcast platform"
  homepage "https://play.pocketcasts.com/"

  livecheck do
    url "https://pocketcasts.com/get/mac"
    strategy :header_match
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Pocket Casts.app"

  zap trash: [
    "~/Library/Application Support/au.com.shiftyjelly.PocketCasts",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.electron.pocket-casts.sfl*",
    "~/Library/Application Support/Pocket Casts",
    "~/Library/Caches/au.com.shiftyjelly.PocketCasts",
    "~/Library/Caches/com.electron.pocket-casts*",
    "~/Library/HTTPStorages/com.electron.pocket-casts",
    "~/Library/Preferences/au.com.shiftyjelly.PocketCasts.plist",
    "~/Library/Preferences/com.electron.pocket-casts.plist",
    "~/Library/Saved Application State/com.electron.pocket-casts.savedState",
  ]
end