cask "medis" do
  version "2.15.1"
  sha256 "70e0cab62c3306aa097c5d5000a0d14e555019f17dc2f1743c0a158f035ba7e9"

  url "https://api.getmedis.com/medis-#{version}.zip"
  name "Medis"
  desc "Modern GUI for Redis"
  homepage "https://getmedis.com/"

  livecheck do
    url "https://api.appcenter.ms/v0.1/public/sparkle/apps/d33d1248-5582-4304-b45c-cb40d51da2ab"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :big_sur"

  app "Medis.app"

  zap trash: [
    "~/Library/Application Support/li.zihua.medis*",
    "~/Library/Caches/li.zihua.medis*",
    "~/Library/HTTPStorages/li.zihua.medis*",
    "~/Library/Preferences/li.zihua.medis*.plist",
  ]
end