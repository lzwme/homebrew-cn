cask "http-toolkit" do
  version "1.19.3"
  sha256 "828914bb71bca38aebb73a32d4a7854b8d4f404efdc011bf1e6e0a00ef1f53b3"

  url "https:github.comhttptoolkithttptoolkit-desktopreleasesdownloadv#{version}HttpToolkit-#{version}.dmg",
      verified: "github.comhttptoolkithttptoolkit-desktop"
  name "HTTP Toolkit"
  desc "HTTP(S) debugging proxy, analyzer, and client"
  homepage "https:httptoolkit.tech"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

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