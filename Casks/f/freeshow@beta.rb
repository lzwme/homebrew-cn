cask "freeshow@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.5.9-beta.1"
  sha256 arm:   "c2b7eccc4c2c2bddc79a0337e5ca5094d99d64de456b85bdbcc4ab17b822d32f",
         intel: "83add6b44501866ad6e9bba023313798014a2eaabf185e85d3967393ab3648e1"

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