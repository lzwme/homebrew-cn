cask "font-ibm-plex-sans-condensed" do
  version "1.1.0"
  sha256 "c172bedb417831bc6ba35ccb727f33959b7f2f8382902386947660bcd66a8077"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-condensed%40#{version}ibm-plex-sans-condensed.zip"
  name "IBM Plex Sans Condensed"
  homepage "https:github.comIBMplex"

  no_autobump! because: :requires_manual_review

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