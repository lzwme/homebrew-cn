cask "marsedit" do
  version "5.3"
  sha256 "fb14141a0aefe694f78ec13581fed0f3c191db5627d756a281e0c489c4243c90"

  url "https://redsweater.com/marsedit/MarsEdit#{version}.zip"
  name "MarsEdit"
  desc "Tool to write, preview and publish blogs"
  homepage "https://redsweater.com/marsedit/"

  livecheck do
    url "https://redsweater.com/marsedit/appcast#{version.major}.php"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "MarsEdit.app"

  zap trash: [
    "~/Library/Application Scripts/com.red-sweater.*",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.red-sweater.marsedit*",
    "~/Library/Caches/com.apple.helpd/Generated/com.red-sweater.marsedit*",
    "~/Library/Containers/com.red-sweater.marsedit*",
    "~/Library/Group Containers/493CVA9A35.com.red-sweater",
  ]
end