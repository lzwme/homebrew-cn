cask "synalyze-it-pro" do
  version "1.32"
  sha256 "cdf639e201a7e859050f61d0b31a598e71f1df9795613bed351e619596f31fc9"

  url "https://www.synalyze-it.com/Downloads/SynalyzeItProTA_#{version}.zip",
      verified: "synalyze-it.com/Downloads/"
  name "Synalyze It! Pro"
  desc "Hex editing and binary file analysis app"
  homepage "https://www.synalysis.net/"

  livecheck do
    url "https://www.synalyze-it.com/SynalyzeItPro/appcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Synalyze It! Pro.app"

  zap trash: [
    "~/Library/Application Support/com.synalyze-it.SynalyzeItPro",
    "~/Library/Caches/com.synalyze-it.SynalyzeItPro",
    "~/Library/HTTPStorages/com.synalyze-it.SynalyzeItPro",
    "~/Library/Preferences/com.synalyze-it.SynalyzeItPro.plist",
    "~/Library/Saved Application State/com.synalyze-it.SynalyzeItPro.savedState",
    "~/Library/WebKit/com.synalyze-it.SynalyzeItPro",
  ]
end