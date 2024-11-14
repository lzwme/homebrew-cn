cask "font-ibm-plex-sans-devanagari" do
  version "1.1.0"
  sha256 "effc4a35b2908c80806c97a4d5033e63f437611d17a3e09b237edd5c33d8ac94"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-devanagari%40#{version}ibm-plex-sans-devanagari.zip"
  name "IBM Plex Sans Devanagari"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-devanagari@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-devanagarifontscompleteotfIBMPlexSansDevanagari-Bold.otf"
  font "ibm-plex-sans-devanagarifontscompleteotfIBMPlexSansDevanagari-ExtraLight.otf"
  font "ibm-plex-sans-devanagarifontscompleteotfIBMPlexSansDevanagari-Light.otf"
  font "ibm-plex-sans-devanagarifontscompleteotfIBMPlexSansDevanagari-Medium.otf"
  font "ibm-plex-sans-devanagarifontscompleteotfIBMPlexSansDevanagari-Regular.otf"
  font "ibm-plex-sans-devanagarifontscompleteotfIBMPlexSansDevanagari-SemiBold.otf"
  font "ibm-plex-sans-devanagarifontscompleteotfIBMPlexSansDevanagari-Text.otf"
  font "ibm-plex-sans-devanagarifontscompleteotfIBMPlexSansDevanagari-Thin.otf"

  # No zap stanza required
end