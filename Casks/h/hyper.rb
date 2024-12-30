cask "hyper" do
  arch arm: "arm64", intel: "x64"
  livecheck_arch = on_arch_conditional arm: "_arm64"

  version "3.4.1"
  sha256 arm:   "7d2440fdd93fde4101e603fe2de46732b54292a868ad17dbcb55288e6f8430a8",
         intel: "aa6ab73fdc60f60d428eb0247b270f958e58709249077b5102c7ab24aff19683"

  url "https:github.comvercelhyperreleasesdownloadv#{version}Hyper-#{version}-mac-#{arch}.zip",
      verified: "github.comvercelhyper"
  name "Hyper"
  desc "Terminal built on web technologies"
  homepage "https:hyper.is"

  livecheck do
    url "https:releases.hyper.isupdatemac#{livecheck_arch}0.0.0"
    strategy :json do |json|
      json["name"]&.delete_prefix("v")
    end
  end

  auto_updates true
  conflicts_with cask: "hyper@canary"

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