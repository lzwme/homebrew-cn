cask "font-ibm-plex-sans-thai-looped" do
  version "1.0.0"
  sha256 "734b854b745c715123713b283a077d587800c1de0e2d6c84e524862d58a649e6"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-thai-looped%40#{version}ibm-plex-sans-thai-looped.zip"
  name "IBM Plex Sans Thai Looped"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-thai-looped@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-thai-loopedfontscompleteotfIBMPlexSansThaiLooped-Bold.otf"
  font "ibm-plex-sans-thai-loopedfontscompleteotfIBMPlexSansThaiLooped-ExtraLight.otf"
  font "ibm-plex-sans-thai-loopedfontscompleteotfIBMPlexSansThaiLooped-Light.otf"
  font "ibm-plex-sans-thai-loopedfontscompleteotfIBMPlexSansThaiLooped-Medium.otf"
  font "ibm-plex-sans-thai-loopedfontscompleteotfIBMPlexSansThaiLooped-Regular.otf"
  font "ibm-plex-sans-thai-loopedfontscompleteotfIBMPlexSansThaiLooped-SemiBold.otf"
  font "ibm-plex-sans-thai-loopedfontscompleteotfIBMPlexSansThaiLooped-Text.otf"
  font "ibm-plex-sans-thai-loopedfontscompleteotfIBMPlexSansThaiLooped-Thin.otf"

  # No zap stanza required
end