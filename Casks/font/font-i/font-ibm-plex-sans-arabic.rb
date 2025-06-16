cask "font-ibm-plex-sans-arabic" do
  version "1.1.0"
  sha256 "f03915581aea37d82792c188b08064023a73494d679b8e19f85f5971db714013"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-arabic%40#{version}ibm-plex-sans-arabic.zip"
  name "IBM Plex Sans Arabic"
  homepage "https:github.comIBMplex"

  no_autobump! because: :requires_manual_review

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