cask "font-ibm-plex-sans-hebrew" do
  version "1.1.0"
  sha256 "d7d490b8a767b972a7f361055fdcf60ad7cb7c270b38ff1bf859562a021369fd"

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