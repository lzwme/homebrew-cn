cask "pika@beta" do
  version "1.3.1-beta1"
  sha256 "5a4f9c1f626078a44413f86a59c4e08042fb8756d0bea268868c31a71d9bb851"

  url "https://ghfast.top/https://github.com/superhighfives/pika/releases/download/#{version}/Pika-#{version}.dmg",
      verified: "github.com/superhighfives/pika/"
  name "Pika"
  desc "Colour picker for colours onscreen"
  homepage "https://superhighfives.com/pika"

  livecheck do
    url "https://superhighfives.com/releases/pika/betas"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  conflicts_with cask: "pika"
  depends_on macos: ">= :sonoma"

  app "Pika.app"

  zap trash: [
    "~/Library/Application Scripts/com.superhighfives.Pika-LaunchAtLoginHelper",
    "~/Library/Containers/com.superhighfives.Pika-LaunchAtLoginHelper",
    "~/Library/Preferences/com.superhighfives.Pika.plist",
  ]
end