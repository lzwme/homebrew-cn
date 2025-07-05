cask "popo" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_arch = on_arch_conditional arm: "arm", intel: "intel"

  on_arm do
    version "4.22.0,1751466386875"
    sha256 "7dad1147ee06a583b09efb5a21672a1631f7c6ef76ea2f13b30cc0ed1b77c97d"
  end
  on_intel do
    version "4.22.0,1751466391344"
    sha256 "c0d08ecb6b2b2118bfc4af7ad482638e1ab8805f79e6bd865915c76fbef01ad3"
  end

  url "https://popo.netease.com/file/popomac/POPO_Mac_#{arch}_prod_#{version.csv.second}.dmg"
  name "NetEase POPO"
  desc "Instant messaging platform"
  homepage "https://popo.netease.com/"

  livecheck do
    url "https://popo.netease.com/api/open/jsonp/check_version?device=4&callback=callback"
    regex(/POPO[._-]Mac[._-]#{arch}[._-]prod[._-](\d+)\.dmg/i)
    strategy :page_match do |page, regex|
      json_regex = /callback\((.+)\)/i

      match = page.match(json_regex)
      next if match.blank?

      json = Homebrew::Livecheck::Strategy::Json.parse_json(match[1])
      version = json.dig("data", "version")
      next if version.blank?

      match = json.dig("data", "#{livecheck_arch}Url")&.match(regex)
      next if match.blank?

      "#{version},#{match[1]}"
    end
  end

  depends_on macos: ">= :big_sur"

  app "popo_mac.app"

  zap trash: [
    "~/Library/Application Support/Netease/Popo",
    "~/Library/Caches/com.netease.game.popo",
    "~/Library/Preferences/com.netease.game.popo.plist",
    "~/Library/Saved Application State/com.netease.game.popo.savedState",
  ]
end