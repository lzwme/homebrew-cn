cask "flycast" do
  version "2.3"
  sha256 "abf46c3ec2cf7059f765d23fe8bd7b9febac652f4b943188048f0c327aa06f0c"

  url "https:github.comflyingheadflycastreleasesdownloadv#{version}flycast-macOS-#{version}.zip"
  name "Flycast"
  desc "Dreamcast, Naomi and Atomiswave emulator"
  homepage "https:github.comflyingheadflycast"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Flycast.app"

  zap rmdir: [
    "LibraryApplication SupportFlycast",
    "~.flycast",
    "~.reicast",
  ]
end