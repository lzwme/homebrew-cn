cask "chrome-devtools" do
  version "1.1.0"
  sha256 "decb98cf06ed9dd65301449347e788dd757315460cf3c77ad91ceb3ef503831a"

  url "https://ghfast.top/https://github.com/auchenberg/chrome-devtools-app/releases/download/v#{version}/chrome-devtools-app_#{version}.dmg"
  name "Chrome DevTools"
  desc "Standalone Chrome development tools"
  homepage "https://github.com/auchenberg/chrome-devtools-app"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Chrome DevTools App.app"

  zap trash: [
    "~/Library/Application Support/Chrome DevTools App",
    "~/Library/Caches/Chrome DevTools App",
    "~/Library/Preferences/com.auchenberg.chrome-devtools-app.plist",
    "~/Library/Saved Application State/com.auchenberg.chrome-devtools-app.savedState",
  ]

  caveats do
    requires_rosetta
  end
end