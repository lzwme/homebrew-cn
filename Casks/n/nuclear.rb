cask "nuclear" do
  arch arm: "aarch64", intel: "x64"

  version "1.35.0"
  sha256 arm:   "b34029521d0b8db48a5509dee30dc0fbf432c0e037d4513260b23281ff87e7c5",
         intel: "56bc2efc1f2c69c8ed2692f38d308176710573401fb3dfb710dffd3f1503e135"

  url "https://ghfast.top/https://github.com/nukeop/nuclear/releases/download/player%40#{version}/Nuclear_#{version}_#{arch}.dmg",
      verified: "github.com/nukeop/nuclear/"
  name "Nuclear"
  desc "Streaming music player"
  homepage "https://nuclearplayer.com/"

  livecheck do
    url :url
    regex(/^(?:player@)?v?(\d+(?:\.\d+)+)$/i)
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on :macos

  app "Nuclear.app"

  zap trash: [
    "~/Library/Application Support/nuclear",
    "~/Library/Logs/nuclear",
    "~/Library/Preferences/nuclear.plist",
    "~/Library/Saved Application State/nuclear.savedState",
  ]
end