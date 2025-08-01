cask "zazu" do
  version "0.6.0"
  sha256 "a726bd20d64d6f03b3251d7841f94fae0f50103533706e9291233aa3adbecf92"

  url "https://ghfast.top/https://github.com/tinytacoteam/zazu/releases/download/v#{version}/Zazu-#{version}.dmg",
      verified: "github.com/"
  name "Zazu"
  desc "Extensible and open-source launcher for hackers, creators and dabblers"
  homepage "https://zazuapp.org/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Zazu.app"

  zap trash: [
    "~/Library/Application Support/Zazu",
    "~/Library/Caches/Zazu",
    "~/Library/Preferences/com.tinytacoteam.zazu.helper.plist",
    "~/Library/Preferences/com.tinytacoteam.zazu.plist",
  ]
end