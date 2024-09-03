cask "font-ibm-plex-sans" do
  version "1.0.0"
  sha256 "4aef1ff11b58892e1fb18383c1ea45544f87c9793b95216a357d4009ed927361"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans%40#{version}ibm-plex-sans.zip"
  name "IBM Plex Sans"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sansfontscompleteotfIBMPlexSans-Bold.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-BoldItalic.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-ExtraLight.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-ExtraLightItalic.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-Italic.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-Light.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-LightItalic.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-Medium.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-MediumItalic.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-Regular.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-SemiBold.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-SemiBoldItalic.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-Text.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-TextItalic.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-Thin.otf"
  font "ibm-plex-sansfontscompleteotfIBMPlexSans-ThinItalic.otf"

  # No zap stanza required
end