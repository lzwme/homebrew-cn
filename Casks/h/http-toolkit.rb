cask "http-toolkit" do
  arch arm: "arm64", intel: "x64"

  version "1.20.0"
  sha256 arm:   "04aa78ab47d835ed0f877c6a591194fbd91ba76a61f27a42f394cde3eb4bb0d7",
         intel: "b0fad18d6458112610dbe0a5848da3ae2196fbcefe8be5df24d713f10fe65ca0"

  url "https:github.comhttptoolkithttptoolkit-desktopreleasesdownloadv#{version}HttpToolkit-#{version}-#{arch}.dmg",
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
end