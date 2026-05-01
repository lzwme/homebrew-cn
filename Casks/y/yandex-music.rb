cask "yandex-music" do
  version "5.100.1"
  sha256 "8766cda52c3f2819b7551c802444a3230b5cd0a5cc5c4761bd9400685db2d7ca"

  url "https://desktop.app.music.yandex.net/stable/Yandex_Music_universal_#{version}.dmg",
      verified: "desktop.app.music.yandex.net/stable/"
  name "Yandex Music"
  desc "Tune in to Yandex Music and get personal recommendations"
  homepage "https://music.yandex.ru/"

  livecheck do
    url "https://desktop.app.music.yandex.net/stable/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Яндекс Музыка.app"

  zap trash: [
    "~/Library/Application Support/YandexMusic",
    "~/Library/Logs/YandexMusic",
    "~/Library/Saved Application State/ru.yandex.desktop.music.savedState",
  ]
end