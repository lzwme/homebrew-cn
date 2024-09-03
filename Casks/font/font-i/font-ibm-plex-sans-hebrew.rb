cask "font-ibm-plex-sans-hebrew" do
  version "1.0.0"
  sha256 "06ad64c91a9e485a80b2c16f38e60659f0e75c0cfe3ceae23dd7830adde667c2"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-hebrew%40#{version}ibm-plex-sans-hebrew.zip"
  name "IBM Plex Sans Hebrew"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-hebrew@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-hebrewfontscompleteotfIBMPlexSansHebrew-Bold.otf"
  font "ibm-plex-sans-hebrewfontscompleteotfIBMPlexSansHebrew-ExtraLight.otf"
  font "ibm-plex-sans-hebrewfontscompleteotfIBMPlexSansHebrew-Light.otf"
  font "ibm-plex-sans-hebrewfontscompleteotfIBMPlexSansHebrew-Medium.otf"
  font "ibm-plex-sans-hebrewfontscompleteotfIBMPlexSansHebrew-Regular.otf"
  font "ibm-plex-sans-hebrewfontscompleteotfIBMPlexSansHebrew-SemiBold.otf"
  font "ibm-plex-sans-hebrewfontscompleteotfIBMPlexSansHebrew-Text.otf"
  font "ibm-plex-sans-hebrewfontscompleteotfIBMPlexSansHebrew-Thin.otf"

  # No zap stanza required
end