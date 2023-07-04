cask "font-overpass" do
  version "3.0.5"
  sha256 "56e62646a3e8f9b9aab57523b9c57eaca8fba79fb55a50f80d2fce0688344159"

  url "https://ghproxy.com/https://github.com/RedHatOfficial/Overpass/archive/refs/tags/v#{version}.zip",
      verified: "github.com/RedHatOfficial/Overpass/"
  name "Overpass"
  homepage "https://overpassfont.org/"

  font "Overpass-#{version}/desktop-fonts/overpass/overpass-bold-italic.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-bold.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-extrabold-italic.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-extrabold.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-extralight-italic.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-extralight.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-heavy-italic.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-heavy.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-italic.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-light-italic.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-light.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-regular.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-semibold-italic.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-semibold.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-thin-italic.otf"
  font "Overpass-#{version}/desktop-fonts/overpass/overpass-thin.otf"
  font "Overpass-#{version}/desktop-fonts/overpass-mono/overpass-mono-bold.otf"
  font "Overpass-#{version}/desktop-fonts/overpass-mono/overpass-mono-light.otf"
  font "Overpass-#{version}/desktop-fonts/overpass-mono/overpass-mono-regular.otf"
  font "Overpass-#{version}/desktop-fonts/overpass-mono/overpass-mono-semibold.otf"

  # No zap stanza required
end