cask "mochi" do
  arch arm: "-arm64"

  version "1.21.0"
  sha256 arm:   "1ad740c166f1daa092a22d328162d1fe59242df9aa243df187d032b356dd52ba",
         intel: "cca596a90430f54cc755e6db0fa0c679db0a0f4a3621258e885c3960fbed8db9"

  url "https://download.mochi.cards/releases/Mochi-#{version}#{arch}.dmg"
  name "Mochi"
  desc "Study notes and flashcards using spaced repetition"
  homepage "https://mochi.cards/"

  livecheck do
    url "https://download.mochi.cards/releases/latest-mac.yml"
    strategy :electron_builder
  end

  depends_on macos: ">= :big_sur"

  app "Mochi.app"

  zap trash: [
    "~/Library/Application Support/mochi",
    "~/Library/Logs/Mochi",
    "~/Library/Preferences/com.msteedman.mochi.plist",
    "~/Library/Saved Application State/com.msteedman.mochi.savedState",
  ]
end