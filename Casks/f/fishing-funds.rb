cask "fishing-funds" do
  arch arm: "-arm64"

  version "8.2.3"
  sha256 arm:   "cfd99745c23aee47fdb27570fd15cdef1d45ff284c354a7077502784cb094e46",
         intel: "201e40902da65f0880035599e5857b479b21a71ea264a74ff9390298b7e86611"

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