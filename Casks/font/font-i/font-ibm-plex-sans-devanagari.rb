cask "font-ibm-plex-sans-devanagari" do
  version "1.0.0"
  sha256 "33d7517d3a67968f4db557a369861680c8f93e68c925754a5d7893e371d4c6c8"

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