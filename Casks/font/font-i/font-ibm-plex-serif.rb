cask "font-ibm-plex-serif" do
  version "1.1.0"
  sha256 "76f1a272b084d2beedcd22aaaa653bc6f92b71b5689081aef9c5b05d0a470e1b"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-serif%40#{version}ibm-plex-serif.zip"
  name "IBM Plex Serif"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-serif@?(\d+(?:\.\d+)+)$}i)
  end

  no_autobump! because: :requires_manual_review

  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-Bold.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-BoldItalic.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-ExtraLight.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-ExtraLightItalic.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-Italic.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-Light.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-LightItalic.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-Medium.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-MediumItalic.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-Regular.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-SemiBold.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-SemiBoldItalic.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-Text.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-TextItalic.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-Thin.otf"
  font "ibm-plex-seriffontscompleteotfIBMPlexSerif-ThinItalic.otf"

  # No zap stanza required
end