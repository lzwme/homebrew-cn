# This cask does not work yet...
cask "ultrastar-creator" do
  arch arm: "ARM", intel: "x86"

  version "1.3.1"
  sha256 arm:   "312fffe016282ef68a06b64e9049133b9e3b622d848f7acd6111fe9d39ef9132",
         intel: "88b909eb272713bf778c3c376ce8fd39489b99c120a4235468f9f423d223bfa3"

  url "https://ghfast.top/https://github.com/UltraStar-Deluxe/UltraStar-Creator/releases/download/#{version}/MAC-#{arch}-UltraStar-Creator.dmg"
  name "UltraStar Creator"
  desc "Create UltraStar karaoke songs from scratch"
  homepage "https://github.com/UltraStar-Deluxe/UltraStar-Creator"

  livecheck do
    url :stable
  end

  app "UltraStar-Creator.app"
end