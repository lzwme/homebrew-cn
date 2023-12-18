cask "fishing-funds" do
  arch arm: "-arm64"

  version "8.1.1"
  sha256 arm:   "449aff2855b18146b6d661f484638cd66e6e855b4000bbf853feb121de9cc764",
         intel: "3725241dd9296fe8a8236672515d3b0073792972194fd05297267ae1dfaf1eaf"

  url "https:github.com1zilcfishing-fundsreleasesdownloadv#{version}Fishing-Funds-#{version}#{arch}.dmg",
      verified: "github.com1zilcfishing-funds"
  name "Fishing Funds"
  desc "Display real-time trends of Chinese funds in the menubar"
  homepage "https:ff.1zilc.top"

  app "Fishing Funds.app"

  zap trash: [
    "~LibraryApplication SupportFishing Funds",
    "~LibraryLogsFishing Funds",
    "~LibraryPreferencescom.electron.1zilc.fishing-funds.plist",
  ]
end