cask "appium" do
  version "1.22.3-4"
  sha256 "907265e27ba854f4ec66c2fea55ac2f8756264783d69b000d447b841d407e753"

  url "https:github.comappiumappium-desktopreleasesdownloadv#{version}Appium-Server-GUI-mac-#{version}.dmg",
      verified: "github.comappiumappium-desktop"
  name "Appium Server Desktop GUI"
  desc "Graphical frontend to Appium automation server"
  homepage "https:appium.io"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Appium Server GUI.app"

  zap trash: [
    "~LibraryApplication Supportappium-desktop",
    "~LibraryPreferencesio.appium.desktop.helper.plist",
    "~LibraryPreferencesio.appium.desktop.plist",
    "~LibrarySaved Application Stateio.appium.desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end