cask "font-fontawesome" do
  version "6.7.0"
  sha256 "0494ff2d3b05dff36e4e72204aa1a98fdee24a78fede6005f882e28d46037b28"

  url "https:github.comFortAwesomeFont-Awesomereleasesdownload#{version}fontawesome-free-#{version}-desktop.zip",
      verified: "github.comFortAwesomeFont-Awesome"
  name "Font Awesome"
  homepage "https:fontawesome.com"

  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Brands-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Solid-900.otf"

  # No zap stanza required
end