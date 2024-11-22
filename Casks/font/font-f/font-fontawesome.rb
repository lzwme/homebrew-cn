cask "font-fontawesome" do
  version "6.7.1"
  sha256 "3118838d8d0aa88b8c9a5e132f8a195a3f1b23895ae66c61dc6746f9ceef80da"

  url "https:github.comFortAwesomeFont-Awesomereleasesdownload#{version}fontawesome-free-#{version}-desktop.zip",
      verified: "github.comFortAwesomeFont-Awesome"
  name "Font Awesome"
  homepage "https:fontawesome.com"

  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Brands-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Solid-900.otf"

  # No zap stanza required
end