cask "hyper-canary" do
  arch arm: "arm64", intel: "x64"

  version "4.0.0-canary.5"
  sha256 arm:   "b23c51a1a2c6a0c1940965f959d30a6a185111954204132402aa29038d30ad98",
         intel: "4f0182611a650e83a8b5084e6f64e03c62c600641d5adb5af6f3253a796415d8"

  url "https:github.comvercelhyperreleasesdownloadv#{version}Hyper-#{version}-mac-#{arch}.zip",
      verified: "github.comvercelhyper"
  name "Hyper"
  desc "Terminal built on web technologies"
  homepage "https:hyper.is"

  livecheck do
    url "https:releases-canary.hyper.is"
    regex(hyper-(\d+(?:\.\d+)*.+)-mac-#{arch}\.zipi)
  end

  auto_updates true
  conflicts_with cask: "hyper"
  depends_on macos: ">= :high_sierra"

  app "Hyper.app"
  binary "#{appdir}Hyper.appContentsResourcesbinhyper"

  zap trash: [
    "~.hyper.js",
    "~.hyper_plugins",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.zeit.hyper.sfl*",
    "~LibraryApplication SupportHyper",
    "~LibraryCachesco.zeit.hyper",
    "~LibraryCachesco.zeit.hyper.ShipIt",
    "~LibraryCookiesco.zeit.hyper.binarycookies",
    "~LibraryLogsHyper",
    "~LibraryPreferencesByHostco.zeit.hyper.ShipIt.*.plist",
    "~LibraryPreferencesco.zeit.hyper.helper.plist",
    "~LibraryPreferencesco.zeit.hyper.plist",
    "~LibrarySaved Application Stateco.zeit.hyper.savedState",
  ]
end