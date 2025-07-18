cask "yoda" do
  version "1.0.1"
  sha256 "4bed8d0f1e4a1be684fc4faf91bfd828f0f8cb6f7a3e4b60d28f0c4b1a94fdef"

  url "https://ghfast.top/https://github.com/whoisandy/yoda/releases/download/v#{version}/yoda-installer-#{version}.dmg"
  name "Yoda"
  desc "App to browse and download YouTube videos"
  homepage "https://github.com/whoisandy/yoda"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-09-01", because: :unmaintained

  app "Yoda.app"

  zap trash: [
    "~/Library/Application Support/yoda",
    "~/Library/Caches/yoda",
    "~/Library/Preferences/com.whoisandie.yoda.plist",
    "~/Library/Saved Application State/com.whoisandie.yoda.savedState",
  ]

  caveats do
    requires_rosetta
  end
end