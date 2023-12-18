cask "font-overpass" do
  version "3.0.5"
  sha256 "56e62646a3e8f9b9aab57523b9c57eaca8fba79fb55a50f80d2fce0688344159"

  url "https:github.comRedHatOfficialOverpassarchiverefstagsv#{version}.zip",
      verified: "github.comRedHatOfficialOverpass"
  name "Overpass"
  homepage "https:overpassfont.org"

  font "Overpass-#{version}desktop-fontsoverpassoverpass-bold-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-bold.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-extrabold-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-extrabold.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-extralight-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-extralight.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-heavy-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-heavy.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-light-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-light.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-regular.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-semibold-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-semibold.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-thin-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-thin.otf"
  font "Overpass-#{version}desktop-fontsoverpass-monooverpass-mono-bold.otf"
  font "Overpass-#{version}desktop-fontsoverpass-monooverpass-mono-light.otf"
  font "Overpass-#{version}desktop-fontsoverpass-monooverpass-mono-regular.otf"
  font "Overpass-#{version}desktop-fontsoverpass-monooverpass-mono-semibold.otf"

  # No zap stanza required
end