cask "font-ibm-plex-sans-condensed" do
  version "1.0.0"
  sha256 "4c3298d50688e08ebbc9f238a1f1dfe907f9bcdabaf0c2c3aab0fbeaa3e1d38d"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-condensed%40#{version}ibm-plex-sans-condensed.zip"
  name "IBM Plex Sans Condensed"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-condensed@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-Bold.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-BoldItalic.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-ExtraLight.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-ExtraLightItalic.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-Italic.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-Light.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-LightItalic.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-Medium.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-MediumItalic.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-Regular.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-SemiBold.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-SemiBoldItalic.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-Text.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-TextItalic.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-Thin.otf"
  font "ibm-plex-sans-condensedfontscompleteotfIBMPlexSansCondensed-ThinItalic.otf"

  # No zap stanza required
end