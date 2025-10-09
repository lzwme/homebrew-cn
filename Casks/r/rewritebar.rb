cask "rewritebar" do
  version "2.17.3"
  sha256 "ffffdc6dea329c5649e530a85f931db9322e41401eebb345b9e24d87ddbc3290"

  url "https://rewritebar.com/download/v#{version}.zip"
  name "RewriteBar"
  desc "AI-powered writing assistant"
  homepage "https://rewritebar.com/"

  livecheck do
    url "https://rewritebar.com/app/appcast.xml"
    strategy :sparkle do |items|
      items.find { |item| item.channel.nil? }&.short_version
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "RewriteBar.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.m91michel.rewritebar.*",
    "~/Library/Application Support/RewriteBar",
    "~/Library/Caches/RewriteBar",
    "~/Library/HTTPStorages/RewriteBar",
    "~/Library/Preferences/com.m91michel.rewritebar.plist",
    "~/Library/Saved Application State/com.m91michel.rewritebar.savedState",
    "~/Library/WebKit/RewriteBar",
  ]
end