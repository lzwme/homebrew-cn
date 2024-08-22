cask "gdevelop" do
  version "5.4.209"
  sha256 "34d57c721848100b053a7259b4b664754eb7c566d35f292914490306e7d9db82"

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