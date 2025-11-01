cask "macwhisper" do
  version "13.0.5,1329"
  sha256 "66e209561a65efcbbef55db951da887c19bc8496aacb6d7786fcf2e278f3e949"

  url "https://cdn.macwhisper.com/macwhisper/MacWhisper-#{version.csv.second}#{"_#{version.csv.third}" if version.csv.third}.zip",
      verified: "cdn.macwhisper.com/"
  name "MacWhisper"
  desc "Speech recognition tool"
  homepage "https://goodsnooze.gumroad.com/l/macwhisper"

  # Older items in the Sparkle feed may have a newer pubDate, so it's necessary
  # to work with all of the items in the feed (not just the newest one).
  livecheck do
    url "https://macwhisper-site.vercel.app/appcast.xml"
    regex(/MacWhisper[._-]v?(?:\d+(?:\.\d+)*)(?:_(\h+))?\.zip/i)
    strategy :sparkle do |items, regex|
      items.map do |item|
        version_suffix = item.url.match(regex)
        next item.nice_version if version_suffix.nil? || version_suffix[1].blank?

        "#{item.nice_version},#{version_suffix[1]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :sequoia"

  app "MacWhisper.app"

  zap trash: [
    "~/Library/Application Scripts/com.goodsnooze.MacWhisper",
    "~/Library/Application Support/MacWhisper",
    "~/Library/Caches/com.goodsnooze.MacWhisper",
    "~/Library/Containers/com.goodsnooze.MacWhisper",
    "~/Library/HTTPStorages/com.goodsnooze.MacWhisper",
    "~/Library/HTTPStorages/com.goodsnooze.MacWhisper.binarycookies",
    "~/Library/Preferences/com.goodsnooze.MacWhisper.plist",
    "~/Library/Saved Application State/com.goodsnooze.MacWhisper.savedState",
    "~/Library/WebKit/com.goodsnooze.MacWhisper",
  ]
end