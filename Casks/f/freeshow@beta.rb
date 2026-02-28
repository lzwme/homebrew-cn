cask "freeshow@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.5.9-beta.2"
  sha256 arm:   "6c382b604b9dcc66a5408a5cc64d028fc71409f2e7e27f5bcf3e357323cb536f",
         intel: "0a7f5c65b0426a96a69f23515b91e6059408ea9167111cc4a0dd6d0db0b0d806"

  url "https://ghfast.top/https://github.com/ChurchApps/FreeShow/releases/download/v#{version}/FreeShow-#{version}-#{arch}.zip",
      verified: "github.com/ChurchApps/"
  name "FreeShow"
  desc "Presentation software"
  homepage "https://freeshow.app/"

  livecheck do
    url :url
    regex(/v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)/i)
  end

  auto_updates true
  conflicts_with cask: "freeshow"
  depends_on macos: ">= :big_sur"

  app "FreeShow.app"

  zap trash: [
        "~/Library/Application Support/freeshow",
        "~/Library/Preferences/app.freeshow.plist",
        "~/Library/Saved Application State/app.freeshow.savedState",
      ],
      rmdir: "~/Documents/FreeShow"
end