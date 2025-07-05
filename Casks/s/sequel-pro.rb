cask "sequel-pro" do
  version "1.1.2"
  sha256 "7b34fd63c13e9e9ca4f87d548241ff9df9a266b554af23549efd7be006f387c6"

  url "https://ghfast.top/https://github.com/sequelpro/sequelpro/releases/download/release-#{version}/sequel-pro-#{version}.dmg",
      verified: "github.com/sequelpro/sequelpro/"
  name "Sequel Pro"
  desc "MySQL/MariaDB database management platform"
  homepage "https://www.sequelpro.com/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued, replacement_cask: "sequel-ace"

  app "Sequel Pro.app"

  zap trash: [
    "~/Library/Application Support/Sequel Pro",
    "~/Library/Caches/com.sequelpro.SequelPro",
    "~/Library/Preferences/com.sequelpro.SequelPro.plist",
    "~/Library/Saved Application State/com.sequelpro.SequelPro.savedState",
  ]

  caveats do
    requires_rosetta
  end
end