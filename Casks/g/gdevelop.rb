cask "gdevelop" do
  version "5.4.208"
  sha256 "7022cc5811517aad99466717613e5ca70a1e6bbbc5028c81887158344673cab5"

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