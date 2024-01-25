cask "flycast" do
  version "2.2"
  sha256 "436702143ae8d8bbdd165784245e50249b9e27e56baaaa26823dfcecda56e2c2"

  url "https:github.comflyingheadflycastreleasesdownloadv#{version}flycast-macOS-#{version}.zip"
  name "Flycast"
  desc "Dreamcast, Naomi and Atomiswave emulator"
  homepage "https:github.comflyingheadflycast"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "Flycast.app"

  zap rmdir: [
    "LibraryApplication SupportFlycast",
    "~.flycast",
    "~.reicast",
  ]
end