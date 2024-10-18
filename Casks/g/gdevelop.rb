cask "gdevelop" do
  version "5.4.216"
  sha256 "0e3db8c6ead9a97f751a89ec6d559b53d4ac7bf38eaa93a555ac5537f1432ddd"

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