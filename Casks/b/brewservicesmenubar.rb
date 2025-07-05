cask "brewservicesmenubar" do
  version "4.1"
  sha256 "9736f68d97ccab2028fe1f9167fe60e229562ae10f56f5506585ce4747a3d055"

  url "https://ghfast.top/https://github.com/andrewn/brew-services-menubar/releases/download/v#{version}/BrewServicesMenubar-v#{version}.zip"
  name "Brew Services Menubar"
  desc "Menu item for starting and stopping homebrew services"
  homepage "https://github.com/andrewn/brew-services-menubar"

  no_autobump! because: :requires_manual_review

  app "BrewServicesMenubar.app"

  uninstall quit: "andrewnicolaou.BrewServicesMenubar"

  zap trash: "~/Library/Preferences/andrewnicolaou.BrewServicesMenubar.plist"
end