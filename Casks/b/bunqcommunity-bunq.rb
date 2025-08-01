cask "bunqcommunity-bunq" do
  version "0.9.10"
  sha256 "a4c4efeab6225bf0c74bb6ae0547404eeb1d5886708ca8b9d2f87fac3b21646f"

  url "https://ghfast.top/https://github.com/bunqCommunity/bunqDesktop/releases/download/#{version}/bunqDesktop-#{version}.dmg",
      verified: "github.com/bunqCommunity/bunqDesktop/"
  name "bunqDesktop"
  desc "Unofficial desktop application for the bunq API"
  homepage "https://bunqdesk.top/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "bunqDesktop.app"
end