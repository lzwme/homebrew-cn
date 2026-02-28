cask "itsytv" do
  version "1.4.2"
  sha256 "b373f93e0791037baf8ec6e8f1230925197d6c135f42a6d90bd78695647cf964"

  url "https://ghfast.top/https://github.com/nickustinov/itsytv-macos/releases/download/v#{version}/Itsytv-#{version}.dmg",
      verified: "github.com/nickustinov/itsytv-macos/"
  name "Itsytv"
  desc "Menu bar app for controlling your Apple TV"
  homepage "https://itsytv.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Itsytv.app"

  zap trash: [
    "~/Library/Preferences/app.itsytv.plist",
    "~/Library/Saved Application State/app.itsytv.savedState",
  ]
end