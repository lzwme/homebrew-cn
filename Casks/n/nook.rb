cask "nook" do
  version "1.0.6"
  sha256 "b4f8d4757d7ab4bfba997ff9b11b02ea0f9eb581e4b9abd5ab029fe528fb41de"

  url "https://ghfast.top/https://github.com/nook-browser/Nook/releases/download/v#{version}/Nook-v#{version}.dmg",
      verified: "github.com/nook-browser/Nook/"
  name "Nook"
  desc "Minimal browser with a sidebar-first design"
  homepage "https://browsewithnook.com/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on macos: ">= :sequoia"

  app "Nook.app"

  zap trash: [
    "~/Library/Application Support/Nook",
    "~/Library/Caches/io.browsewithnook.nook",
    "~/Library/Preferences/io.browsewithnook.nook.plist",
  ]
end