cask "chrome-devtools" do
  version "1.1.0"
  sha256 "decb98cf06ed9dd65301449347e788dd757315460cf3c77ad91ceb3ef503831a"

  url "https:github.comauchenbergchrome-devtools-appreleasesdownloadv#{version}chrome-devtools-app_#{version}.dmg"
  name "Chrome DevTools"
  desc "Standalone Chrome development tools"
  homepage "https:github.comauchenbergchrome-devtools-app"

  disable! date: "2024-12-16", because: :discontinued

  app "Chrome DevTools App.app"

  zap trash: [
    "~LibraryApplication SupportChrome DevTools App",
    "~LibraryCachesChrome DevTools App",
    "~LibraryPreferencescom.auchenberg.chrome-devtools-app.plist",
    "~LibrarySaved Application Statecom.auchenberg.chrome-devtools-app.savedState",
  ]

  caveats do
    requires_rosetta
  end
end