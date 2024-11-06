cask "http-toolkit" do
  version "1.19.1"
  sha256 "aae8de3770f00d7be5fc4714d7f809c473fadb920e75dac2ee787dda17f336d6"

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

  caveats do
    requires_rosetta
  end
end