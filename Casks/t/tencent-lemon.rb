cask "tencent-lemon" do
  version "5.1.16,BC4FB28CB59D1A9FEE2D9EDB167B25A9"
  sha256 "7d3ef369137bd51b6653b1fa154d2d8f64705ab8a8d1e8b294176d8b1c40c67b"

  url "https://pm.myapp.com/invc/xfspeed/qqpcmgr/module_update/#{version.csv.second}/Lemon#{version.csv.first}.dmg",
      verified: "pm.myapp.com/invc/xfspeed/qqpcmgr/"
  name "Tencent Lemon Cleaner"
  desc "Cleanup and system status tool"
  homepage "https://lemon.qq.com/"

  livecheck do
    url "https://lemon.guanjia.qq.com/latest/package?version=newTag"
    regex(%r{/module_update/(\h+)/Lemon[._-]?v?(\d+(?:\.\d+)+)\.dmg}i)
    strategy :json do |json, regex|
      match = json.dig("latest", "downloadurl")&.match(regex)
      next if match.blank?

      "#{match[2]},#{match[1]}"
    end
  end

  auto_updates true

  app "Tencent Lemon.app"

  uninstall delete: [
    "/Library/Logs/Lemon",
    "/Library/Preferences/LemonDaemon_packet.dat",
  ]

  zap trash: [
    "~/Library/Caches/com.tencent.Lemon",
    "~/Library/Caches/com.tencent.LemonMonitor",
    "~/Library/Logs/LemonMonitor.log",
    "~/Library/Logs/Tencent Lemon.log",
    "~/Library/Preferences/com.tencent.LemonUpdate.plist",
    "~/Library/Preferences/LemonMonitor_packet.dat",
    "~/Library/Preferences/Tencent Lemon_packet.dat",
  ]
end