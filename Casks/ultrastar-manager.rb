cask "ultrastar-manager" do
  version "1.8.3"
  sha256 "799d1b32dcaad0adf47488e9a601dab4049b126936a2533c090d0683bb848eb4"

  url "https://ghproxy.com/https://github.com/UltraStar-Deluxe/UltraStar-Manager/releases/download/v1.8.3/uman-1.8.3.dmg"
  appcast "https://github.com/UltraStar-Deluxe/UltraStar-Manager/releases.atom"
  name "UltraStar Manager"
  desc "Manager application for UltraStar songs"
  homepage "https://github.com/UltraStar-Deluxe/UltraStar-Manager/"

  app "UltraStarManager.app"
end