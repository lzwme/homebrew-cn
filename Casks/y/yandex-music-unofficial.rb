cask "yandex-music-unofficial" do
  arch arm: "-arm64"

  version "1.8.1"
  sha256 arm:   "dfe7459432eb25870f1e01dc35cb6df10590e0bb7eeb9a1e7a07a644d8ac90a4",
         intel: "8f4aa50707ca5c68896bfec75e989251757fc36452ef0c3fcc73e9a2a6dc46d3"

  url "https:github.comjuvirezyandex-music-appreleasesdownloadv#{version}Yandex-Music-Unofficial-#{version}#{arch}.dmg",
      verified: "github.comjuvirezyandex-music-app"
  name "Yandex Music Unofficial"
  desc "Unofficial app for Yandex Music"
  homepage "https:yandex-music.juvs.dev"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Yandex Music Unofficial.app"

  zap trash: "~LibraryApplication Supportyandex-music-app"
end