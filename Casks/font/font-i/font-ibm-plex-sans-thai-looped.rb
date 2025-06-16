cask "font-ibm-plex-sans-thai-looped" do
  version "1.1.0"
  sha256 "26c453e3a4341026e2f5525cd498c5aa214e57bdb9db99bc3816826a36be157f"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-thai-looped%40#{version}ibm-plex-sans-thai-looped.zip"
  name "IBM Plex Sans Thai Looped"
  homepage "https:github.comIBMplex"

  no_autobump! because: :requires_manual_review

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