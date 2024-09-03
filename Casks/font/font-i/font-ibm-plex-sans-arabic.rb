cask "font-ibm-plex-sans-arabic" do
  version "1.0.0"
  sha256 "759e7a77c4dbae38371e5d3b1016e2ee5f75a164e708a960bb69d8949f0c3593"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-arabic%40#{version}ibm-plex-sans-arabic.zip"
  name "IBM Plex Sans Arabic"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-arabic@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-arabicfontscompleteotfIBMPlexSansArabic-Bold.otf"
  font "ibm-plex-sans-arabicfontscompleteotfIBMPlexSansArabic-ExtraLight.otf"
  font "ibm-plex-sans-arabicfontscompleteotfIBMPlexSansArabic-Light.otf"
  font "ibm-plex-sans-arabicfontscompleteotfIBMPlexSansArabic-Medium.otf"
  font "ibm-plex-sans-arabicfontscompleteotfIBMPlexSansArabic-Regular.otf"
  font "ibm-plex-sans-arabicfontscompleteotfIBMPlexSansArabic-SemiBold.otf"
  font "ibm-plex-sans-arabicfontscompleteotfIBMPlexSansArabic-Text.otf"
  font "ibm-plex-sans-arabicfontscompleteotfIBMPlexSansArabic-Thin.otf"

  # No zap stanza required
end