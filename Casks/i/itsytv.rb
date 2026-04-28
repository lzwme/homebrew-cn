cask "itsytv" do
  version "1.5.2"
  sha256 "4e053c0fe617f752f9e5b4cdfec054f006974e846b8090071dcfebb20753abfa"

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