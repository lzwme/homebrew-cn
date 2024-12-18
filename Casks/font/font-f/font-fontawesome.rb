cask "font-fontawesome" do
  version "6.7.2"
  sha256 "22ff7898b429b997a45e1cf89bb869ed3abcc65333d90289181ba5363c8fd19b"

  url "https:github.comFortAwesomeFont-Awesomereleasesdownload#{version}fontawesome-free-#{version}-desktop.zip",
      verified: "github.comFortAwesomeFont-Awesome"
  name "Font Awesome"
  homepage "https:fontawesome.com"

  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Brands-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Solid-900.otf"

  # No zap stanza required
end