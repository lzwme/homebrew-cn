cask "tiddly" do
  arch arm: "applesilicon", intel: "64"

  version "0.0.20"
  sha256 arm:   "4346518579399ade0b16429860a1fef92940a621c2444094ded21d926d353bb7",
         intel: "d41af9408f0a3f160c486e568883ac55c7388274f63c6ec3117db616de3f1c0c"

  url "https://ghfast.top/https://github.com/Jermolene/TiddlyDesktop/releases/download/v#{version}/tiddlydesktop-mac#{arch}-v#{version}.zip"
  name "TiddlyWiki"
  desc "Browser for TiddlyWiki"
  homepage "https://github.com/Jermolene/TiddlyDesktop"

  # This is the default strategy, but we need to explicitly
  # specify it to continue checking it while it is deprecated
  livecheck do
    url :url
    strategy :git
  end

  disable! date: "2026-09-01", because: :unsigned

  app "TiddlyDesktop-mac#{arch}-v#{version}/TiddlyDesktop.app"

  zap trash: [
    "~/Library/Application Support/TiddlyDesktop",
    "~/Library/Caches/TiddlyDesktop",
    "~/Library/Preferences/com.tiddlywiki.plist",
    "~/Library/Saved Application State/com.tiddlywiki.savedState",
  ]
end