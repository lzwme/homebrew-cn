cask "http-toolkit" do
  arch arm: "arm64", intel: "x64"

  version "1.20.1"
  sha256 arm:   "b9bdb37ab02cc4a818e033f0213437830dc980d6126d22377c5beb61197d538c",
         intel: "1c7a014e6b135745fab6ced49052154d347d139434dd654fc6feabee4c25e1a7"

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