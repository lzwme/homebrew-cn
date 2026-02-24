cask "hotovo-aider-desk" do
  arch arm: "arm64", intel: "x64"

  version "0.54.0"
  sha256 arm:   "2bcfed008e2282acb4c7b3d686ce0cfa7cccd27e47a03e5d4b3fe590fd80b6cb",
         intel: "ea0eb7f627e94743d9db7e89ddd51993076601d6711e41b54fc0c8c0bbb4c2b9"

  url "https://ghfast.top/https://github.com/hotovo/aider-desk/releases/download/v#{version}/aider-desk-#{version}-macos-#{arch}.dmg"
  name "AiderDesk"
  desc "Desktop GUI for Aider AI pair programming"
  homepage "https://github.com/hotovo/aider-desk"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "aider-desk.app"

  zap trash: [
    "~/Library/Application Support/aider-desk",
    "~/Library/Logs/aider-desk",
    "~/Library/Preferences/com.hotovo.aider-desk.plist",
    "~/Library/Saved Application State/com.hotovo.aider-desk.savedState",
  ]
end