cask "insomnia-alpha" do
  version "2023.5.0-beta.9"
  sha256 "ef2838c05e8114f38bb788f9cdaab30b3c6c1600195bf1b087f5eab77e02f166"

  url "https://ghproxy.com/https://github.com/Kong/insomnia/releases/download/core%40#{version}/Insomnia.Core-#{version}.dmg",
      verified: "github.com/Kong/insomnia/"
  name "Insomnia"
  desc "HTTP and GraphQL Client"
  homepage "https://insomnia.rest/"

  livecheck do
    url "https://github.com/Kong/insomnia/releases"
    regex(%r{href=["']?[^"' >]*?/tag/core%40(\d+(?:\.\d+)+[._-](?:alpha|beta)[._-]?\d*)["' >]}i)
    strategy :page_match
  end

  auto_updates true
  conflicts_with cask: "insomnia"

  app "Insomnia.app"

  zap trash: [
    "~/Library/Application Support/Insomnia",
    "~/Library/Caches/com.insomnia.app",
    "~/Library/Caches/com.insomnia.app.ShipIt",
    "~/Library/Cookies/com.insomnia.app.binarycookies",
    "~/Library/Preferences/ByHost/com.insomnia.app.ShipIt.*.plist",
    "~/Library/Preferences/com.insomnia.app.helper.plist",
    "~/Library/Preferences/com.insomnia.app.plist",
    "~/Library/Saved Application State/com.insomnia.app.savedState",
  ]
end