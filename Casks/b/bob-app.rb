cask "bob-app" do
  version "0.10.3"
  sha256 "2e3ff79c0a7f7090ba17382d0e76a1299291d58bd97a3e4816b7eac3f020948d"

  url "https://ghfast.top/https://github.com/ripperhe/Bob/releases/download/v#{version}/Bob.zip"
  name "Bob"
  desc "Translation application for text, pictures, and manual input"
  homepage "https://github.com/ripperhe/Bob"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-04-15", because: :moved_to_mas

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Bob.app"

  zap trash: [
    "~/Library/Application Support/com.ripperhe.Bob",
    "~/Library/Caches/com.ripperhe.Bob",
    "~/Library/HTTPStorages/com.ripperhe.Bob",
    "~/Library/Preferences/com.ripperhe.Bob.plist",
  ]
end