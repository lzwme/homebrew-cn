cask "ultrastar-manager" do
  version "1.8.3"
  sha256 "799d1b32dcaad0adf47488e9a601dab4049b126936a2533c090d0683bb848eb4"

  url "https://ghfast.top/https://github.com/UltraStar-Deluxe/UltraStar-Manager/releases/download/v#{version}/uman-#{version}.dmg"
  name "UltraStar Manager"
  desc "Manager application for UltraStar songs"
  homepage "https://github.com/UltraStar-Deluxe/UltraStar-Manager/"

  livecheck do
    url :stable
  end

  app "UltraStarManager.app"
end