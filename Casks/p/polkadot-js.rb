cask "polkadot-js" do
  version "0.132.1"
  sha256 "4521d91f2ee9bf2df35102ca91bcddba1d46f71dd1901b9dd35725159ee07358"

  url "https:github.compolkadot-jsappsreleasesdownloadv#{version}Polkadot-JS-Apps-mac-#{version}.dmg",
      verified: "github.compolkadot-jsapps"
  name "polkadot{.js}"
  desc "Portal into the Polkadot and Substrate networks"
  homepage "https:polkadot.js.org"

  app "Polkadot-JS Apps.app"

  zap trash: [
    "~LibraryPreferencescom.polkadotjs.polkadotjs-apps.plist",
    "~LibrarySaved Application Statecom.polkadotjs.polkadotjs-apps.savedState",
  ]
end