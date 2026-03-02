cask "emdash" do
  arch arm: "arm64", intel: "x64"

  version "0.4.22"
  sha256 arm:   "5b75afd924bae03e372da0519f77c23245603d66df26faca1ac52bcc3104d579",
         intel: "a47c6e05172469dc908639fd38dfcaa5908bfb18eea0678f0e1740e3f9155369"

  url "https://ghfast.top/https://github.com/generalaction/emdash/releases/download/v#{version}/emdash-#{arch}.dmg",
      verified: "github.com/generalaction/emdash/"
  name "Emdash"
  desc "UI for running multiple coding agents in parallel"
  homepage "https://www.emdash.sh/"

  depends_on macos: ">= :big_sur"

  app "emdash.app"

  zap trash: [
    "/Library/Logs/emdash",
    "/Library/Saved Application State/com.emdash.savedState",
    "~/Library/Application Support/emdash",
    "~/Library/Preferences/com.emdash.plist",
  ]
end