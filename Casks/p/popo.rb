cask "popo" do
  version "4.5.0,1715775402405"
  sha256 "de028e6121790a2170807c059af82c7ec7808f3bbde31fe32d8d192734d23c26"

  url "https://popo.netease.com/file/popomac/POPO-setup_prod_#{version.csv.second}.dmg"
  name "NetEase POPO"
  desc "Instant messaging platform"
  homepage "https://popo.netease.com/"

  livecheck do
    url "https://popo.netease.com/api/open/jsonp/check_version?device=4&callback="
    strategy :page_match do |page|
      match = page.match(/["']version["']\s*:\s*["'](\d+(?:\.\d+)+)["'].*?(\d+)\.dmg/i)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  app "popo_mac.app"

  zap trash: [
    "~/Library/Application Support/Netease/Popo",
    "~/Library/Caches/com.netease.game.popo",
    "~/Library/Preferences/com.netease.game.popo.plist",
    "~/Library/Saved Application State/com.netease.game.popo.savedState",
  ]
end