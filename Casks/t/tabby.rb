cask "tabby" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.233"
  sha256 arm:   "539976c25ff2d3d38423e4a55a09cda6c0ac75705fc6981d31e9213840b72560",
         intel: "1ad6e181d6a4ba2b20a5187d89d0403beb7f43e0f4a04c61a57e4de582d6e1ff"

  url "https://ghfast.top/https://github.com/Eugeny/tabby/releases/download/v#{version}/tabby-#{version}-macos-#{arch}.zip",
      verified: "github.com/Eugeny/tabby/"
  name "Tabby"
  name "Terminus"
  desc "Terminal emulator, SSH and serial client"
  homepage "https://eugeny.github.io/tabby/"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Tabby.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.tabby.sfl*",
    "~/Library/Application Support/tabby",
    "~/Library/Caches/org.tabby",
    "~/Library/Caches/org.tabby.ShipIt",
    "~/Library/HTTPStorages/org.tabby",
    "~/Library/Preferences/ByHost/org.tabby.ShipIt.*.plist",
    "~/Library/Preferences/org.tabby.helper.plist",
    "~/Library/Preferences/org.tabby.plist",
    "~/Library/Saved Application State/org.tabby.savedState",
    "~/Library/Services/Open Tabby here.workflow",
    "~/Library/Services/Paste path into Tabby.workflow",
  ]
end