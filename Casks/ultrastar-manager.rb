cask "ultrastar-manager" do
  version "1.8.3"
  sha256 "799d1b32dcaad0adf47488e9a601dab4049b126936a2533c090d0683bb848eb4"

  url "https:github.comUltraStar-DeluxeUltraStar-Managerreleasesdownloadv#{version}uman-#{version}.dmg"
  name "UltraStar Manager"
  desc "Manager application for UltraStar songs"
  homepage "https:github.comUltraStar-DeluxeUltraStar-Manager"

  livecheck do
    url :stable
  end

  app "UltraStarManager.app"
end