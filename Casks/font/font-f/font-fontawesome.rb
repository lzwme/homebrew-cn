cask "font-fontawesome" do
  version "6.6.0"
  sha256 "8cde9bf442f218ee330844263ee35403ff466a1afbbd11ab170523f3cd09067c"

  url "https:github.comFortAwesomeFont-Awesomereleasesdownload#{version}fontawesome-free-#{version}-desktop.zip",
      verified: "github.comFortAwesomeFont-Awesome"
  name "Font Awesome"
  homepage "https:fontawesome.com"

  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Brands-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Regular-400.otf"
  font "fontawesome-free-#{version}-desktopotfsFont Awesome #{version.major} Free-Solid-900.otf"

  # No zap stanza required
end