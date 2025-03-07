cask "gdevelop" do
  version "5.5.225"
  sha256 "a624c41b9af6b42c9f9b54ada9bf0149d5de46439f1f5e46978a8ccf2c7be42a"

  url "https:github.com4ianGDevelopreleasesdownloadv#{version}GDevelop-#{version.major}-#{version}-universal.dmg",
      verified: "github.com4ianGDevelop"
  name "GDevelop"
  desc "Open-source, cross-platform game engine designed to be used by everyone"
  homepage "https:gdevelop.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "GDevelop #{version.major}.app"

  zap trash: [
    "~LibraryApplication SupportGDevelop #{version.major}",
    "~LibraryLogsGDevelop #{version.major}",
    "~LibraryPreferencescom.gdevelop-app.ide.plist",
    "~LibrarySaved Application Statecom.gdevelop-app.ide.savedState",
  ]
end