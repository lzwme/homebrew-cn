cask "http-toolkit" do
  version "1.14.8"
  sha256 "93e9f5c823372f8bcfa6a6b2342078256f61437e1f4d5dae9efe4a06457f7b9a"

  url "https:github.comhttptoolkithttptoolkit-desktopreleasesdownloadv#{version}HttpToolkit-#{version}.dmg",
      verified: "github.comhttptoolkithttptoolkit-desktop"
  name "HTTP Toolkit"
  desc "HTTP(S) debugging proxy, analyzer, and client"
  homepage "https:httptoolkit.tech"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "HTTP Toolkit.app"

  zap trash: [
    "~LibraryApplication SupportHTTP Toolkit",
    "~LibraryCacheshttptoolkit-server",
    "~LibraryLogsHTTP Toolkit",
    "~LibraryPreferenceshttptoolkit",
    "~LibraryPreferencestech.httptoolkit.desktop.plist",
    "~LibrarySaved Application Statetech.httptoolkit.desktop.savedState",
  ]
end