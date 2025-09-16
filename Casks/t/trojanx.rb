cask "trojanx" do
  version "0.4"
  sha256 "794e02b6b530ea076b5fcc51061efb597cc4ff0a1d8064897bca16122f6fc798"

  url "https://ghfast.top/https://github.com/JimLee1996/TrojanX/releases/download/#{version}/TrojanX.app.zip"
  name "TrojanX"
  desc "Mechanism to bypass the Great Firewall"
  homepage "https://github.com/JimLee1996/TrojanX"

  deprecate! date: "2024-08-30", because: :unmaintained
  disable! date: "2025-08-30", because: :unmaintained

  app "TrojanX.app"

  uninstall delete: "/Library/Application Support/TrojanX"

  zap trash: [
    "~/.TrojanX",
    "~/Library/Application Support/TrojanX",
    "~/Library/Preferences/TrojanX.plist",
  ]

  caveats do
    requires_rosetta
  end
end