cask "android-messages" do
  version "3.1.0"
  sha256 "4f1158c390e98c98516d6b34a98b6037dee55d4484f5aca5df75050ca91ece7f"

  url "https://ghfast.top/https://github.com/chrisknepper/android-messages-desktop/releases/download/v#{version}/Android-Messages-#{version}.dmg"
  name "Android Messages Desktop"
  desc "Desktop client for Android Messages"
  homepage "https://github.com/chrisknepper/android-messages-desktop"

  disable! date: "2024-12-16", because: :discontinued, replacement_cask: "orangedrangon-android-messages"

  conflicts_with cask: "orangedrangon-android-messages"

  app "Android Messages.app"

  zap trash: "~/Library/Application Support/Android Messages"

  caveats do
    requires_rosetta
  end
end