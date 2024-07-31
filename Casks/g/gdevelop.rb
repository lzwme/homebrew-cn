cask "gdevelop" do
  version "5.4.206"
  sha256 "5a80c3c00436f36b480f985b62be5146e5a35cf9ce144b4da327a4c158e67c5f"

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