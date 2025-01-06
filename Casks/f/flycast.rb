cask "flycast" do
  version "2.4"
  sha256 "6606eaef7479bdd5edb161a73968ac982f6867ccf52b951ad01a4b8f49d6a782"

  url "https:github.comflyingheadflycastreleasesdownloadv#{version}flycast-macOS-#{version}.zip"
  name "Flycast"
  desc "Dreamcast, Naomi and Atomiswave emulator"
  homepage "https:github.comflyingheadflycast"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Flycast.app"

  zap rmdir: [
    "LibraryApplication SupportFlycast",
    "~.flycast",
    "~.reicast",
  ]
end