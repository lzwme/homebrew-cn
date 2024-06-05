cask "godspeed" do
  version "1.4.0"
  sha256 "86245a797e492598d1c67e8d645a3d033c9a39ba603174e687627a647a17ab57"

  url "https://app-updates.godspeedapp.com/#{version}%2FGodspeed.zip"
  name "Godspeed"
  desc "Keyboard-focused todo manager"
  homepage "https://godspeedapp.com/"

  livecheck do
    url "https://api.godspeedapp.com/update-check/latest"
    strategy :json do |json|
      json["name"]&.tr("v", "")
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Godspeed.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.godspeedapp.*",
    "~/Library/Application Support/Godspeed",
    "~/Library/Caches/com.godspeedapp.Godspeed",
    "~/Library/Caches/com.godspeedapp.Godspeed.ShipIt",
    "~/Library/HTTPStorages/com.godspeedapp.Godspeed",
    "~/Library/Preferences/com.godspeedapp.Godspeed.plist",
    "~/Library/Saved Application State/com.godspeedapp.Godspeed.savedState",
  ]
end