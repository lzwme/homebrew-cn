cask "kdocs" do
  version "3.11.2,1001"
  sha256 "9fe64f666405af7761e2858dcc486fbfb6a3ee58c242122155d989f5446de681"

  url "https://qn.cache.wpscdn.cn/kdocs/apk/kdesktopmac/KDocs_#{version.csv.second}_v#{version.csv.first}.dmg",
      verified: "qn.cache.wpscdn.cn/kdocs/apk/kdesktopmac/"
  name "金山文档"
  desc "Online collaborate editor for Word, Excel and PPT documents"
  homepage "https://www.kdocs.cn/"

  livecheck do
    url "https://www.kdocs.cn/kdg/api/v1/configure?idList=appOfficial"
    regex(/kdocs[._-](\d+(?:\.\d+)*)[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
    strategy :json do |json, regex|
      json_string = json.dig("data", "appOfficial")
      next if json_string.blank?

      app_json = Homebrew::Livecheck::Strategy::Json.parse_json(json_string)
      match = app_json.dig("kdesktopMacOfficial", 0, "url")&.match(regex)
      next if match.blank?

      "#{match[2]},#{match[1]}"
    end
  end

  depends_on macos: ">= :high_sierra"

  app "金山文档.app"

  zap trash: [
    "~/Library/Preferences/com.kingsoft.kdocs.mac.plist",
    "~/Library/Saved Application State/com.kingsoft.kdocs.mac.savedState",
  ]

  caveats do
    requires_rosetta
  end
end