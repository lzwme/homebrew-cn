cask "font-fontawesome" do
  version "6.5.2"
  sha256 "6392bc956eb3d391c9d7a14e891ce8010226ffc0c75f1338db126f13cb9cb8f4"

  url "https:github.comFortAwesomeFont-Awesomereleasesdownload#{version}fontawesome-free-#{version}-desktop.zip",
      verified: "github.comFortAwesomeFont-Awesome"
  name "Font Awesome"
  homepage "https:fontawesome.com"

  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Brands-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Solid-900.otf"

  # No zap stanza required
end