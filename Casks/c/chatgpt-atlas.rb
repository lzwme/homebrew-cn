cask "chatgpt-atlas" do
  version "1.2025.288.15,20251023205637000"
  sha256 "248dedca3aa9075a5d1b4067af1749575cc7793b85941c18e6c2262cde5a2661"

  url "https://persistent.oaistatic.com/atlas/public/ChatGPT_Atlas_Desktop_public_#{version.csv.first}_#{version.csv.second}.dmg",
      verified: "persistent.oaistatic.com/atlas/public/"
  name "ChatGPT Atlas"
  desc "OpenAI's official browser with ChatGPT built in"
  homepage "https://chatgpt.com/atlas"

  # Some older items in the Sparkle feed have a more recent pubDate, so it's necessary to
  # work with all of the items in the feed (not just the newest one).
  livecheck do
    url "https://persistent.oaistatic.com/atlas/public/sparkle_public_appcast.xml"
    strategy :sparkle do |items|
      items.map(&:nice_version)
    end
  end

  auto_updates true
  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "ChatGPT Atlas.app"

  uninstall quit: "com.openai.atlas"

  zap trash: [
    "~/Library/Application Support/com.openai.atlas",
    "~/Library/Application Support/CrashReporter/ChatGPT Atlas (Service)_*.plist",
    "~/Library/Application Support/OpenAI/ChatGPT Atlas",
    "~/Library/Caches/com.openai.atlas",
    "~/Library/HTTPStorages/com.openai.atlas",
    "~/Library/HTTPStorages/com.openai.atlas.binarycookies",
    "~/Library/Logs/DiagnosticReports/ChatGPT Atlas (Service)*.ips",
    "~/Library/Preferences/com.openai.atlas.plist",
    "~/Library/Preferences/com.openai.atlas.web.plist",
  ]
end