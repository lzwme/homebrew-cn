cask "wetype" do
  version "1.2.0,368"
  sha256 "820209dd7cd28a0b03abf8b76bbcf8989fa97bc5cea2fb1c81027b9a1487573b"

  url "https://download.z.weixin.qq.com/app/mac/#{version.csv.first}/WeTypeInstaller_#{version.csv.first}_#{version.csv.second}.zip"
  name "WeType"
  name "微信输入法"
  desc "Text input app from WeChat team for Chinese users"
  homepage "https://z.weixin.qq.com/"

  livecheck do
    url "https://z.weixin.qq.com/web/api/app_info"
    regex(/WeTypeInstaller[._-]v?(\d+(?:.\d+)+)[._-](\d+).zip/i)
    strategy :json do |json, regex|
      match = json.dig("data", "mac", "download_link")&.match(regex)
      "#{match[1]},#{match[2]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  installer manual: "WeTypeInstaller_#{version.csv.first}_#{version.csv.second}.app"

  uninstall delete: "/Library/Input Methods/WeType.app"

  zap trash: [
    "~/Library/Application Support/WeType",
    "~/Library/Caches/com.tencent.inputmethod.wetype",
    "~/Library/Caches/WeType",
    "~/Library/HTTPStorages/com.tencent.inputmethod.wetype",
    "~/Library/Preferences/com.tencent.inputmethod.wetype.plist",
  ]
end