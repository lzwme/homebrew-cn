cask "android-messages" do
  version "3.1.0"
  sha256 "4f1158c390e98c98516d6b34a98b6037dee55d4484f5aca5df75050ca91ece7f"

  url "https:github.comchrisknepperandroid-messages-desktopreleasesdownloadv#{version}Android-Messages-#{version}.dmg"
  name "Android Messages Desktop"
  desc "Desktop client for Android Messages"
  homepage "https:github.comchrisknepperandroid-messages-desktop"

  deprecate! date: "2023-12-17", because: :discontinued

  conflicts_with cask: "orangedrangon-android-messages"

  app "Android Messages.app"

  zap trash: "~LibraryApplication SupportAndroid Messages"

  caveats do
    requires_rosetta
    <<~EOS
      #{token} has been deprecated in favor of OrangeDrangon Android Messages.
        brew install --cask orangedrangon-android-messages
    EOS
  end
end