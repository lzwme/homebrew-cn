cask "overlayed" do
  version "0.6.2"
  sha256 "b47a390708350d98e524bdc87a06d7e634bdc95e0c4092d06b9f92702b7ed946"

  url "https://ghfast.top/https://github.com/overlayeddev/overlayed/releases/download/v#{version}/overlayed_#{version}_universal.dmg",
      verified: "github.com/overlayeddev/overlayed/"
  name "Overlayed"
  desc "Modern, open-source, and free voice chat overlay for Discord"
  homepage "https://overlayed.dev/"

  app "Overlayed.app"

  zap trash: "~/Library/Application Support/com.hacksore.overlayed"
end