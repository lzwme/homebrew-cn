cask "tower" do
  version "14.0,489,e68a3d23"
  sha256 "82b1ecc9177473cff289aaf5f3586d0d97b27a60c35a23b9485161987b6bc0c0"

  url "https://www.git-tower.com/apps/tower3-mac/#{version.csv.second}-#{version.csv.third}/Tower-#{version.csv.first}-#{version.csv.second}.zip"
  name "Tower"
  desc "Git client focusing on power and productivity"
  homepage "https://www.git-tower.com/"

  livecheck do
    url "https://updates.fournova.com/tower3-mac/stable/updates"
    regex(%r{/tower3-mac/(?:\d+(?:\.\d+)*)-([a-z0-9]+)/}i)
    strategy :sparkle do |item, regex|
      match = item.url.match(regex)
      next if match.blank?

      "#{item.nice_version},#{match[1]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Tower.app"
  binary "#{appdir}/Tower.app/Contents/MacOS/gittower"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.fournova.tower*.sfl*",
    "~/Library/Application Support/com.fournova.Tower*",
    "~/Library/Caches/com.fournova.Tower*",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.fournova.Tower*",
    "~/Library/HTTPStorages/com.fournova.Tower*",
    "~/Library/Preferences/com.fournova.Tower*.plist",
    "~/Library/Saved Application State/com.fournova.Tower*.savedState",
  ]
end