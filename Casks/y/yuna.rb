cask "yuna" do
  version "1.4.23"
  sha256 "9a159f8cd2e16cc4dd31cb3a0f4c30fee20f29cfc77514ac27099561b0893fbd"

  url "https:github.comBeeeQueueyunareleasesdownloadv#{version}Yuna-#{version}.dmg",
      verified: "github.comBeeeQueueyuna"
  name "Yuna"
  desc "Anime player and list manager"
  homepage "https:yuna.moe"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-06-24", because: :no_longer_available

  app "Yuna.app"

  zap trash: "~LibraryApplication Supportyuna"
end