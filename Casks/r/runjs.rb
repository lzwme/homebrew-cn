cask "runjs" do
  version "3.2.1"
  sha256 "69d41e8b4089342c9346be8f6df9f91650d08d5f29fbf61df7eb9a60a50edd4e"

  url "https://ghfast.top/https://github.com/lukehaas/RunJS/releases/download/v#{version}/RunJS-#{version}-universal.dmg",
      verified: "github.com/lukehaas/RunJS/"
  name "RunJS"
  desc "JavaScript playground that auto-evaluates as code is typed"
  homepage "https://runjs.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "RunJS.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/me.lukehaas.runjs.sfl*",
    "~/Library/Application Support/runjs",
    "~/Library/Logs/RunJS",
    "~/Library/Preferences/me.lukehaas.runjs.plist",
    "~/Library/Saved Application State/me.lukehaas.runjs.savedState",
  ]
end