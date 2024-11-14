cask "font-ibm-plex-sans-jp" do
  version "1.1.0"
  sha256 "96e7b8af07b5b38fad9c531c11854559c47332b45de7e65c45672b5415f3cd55"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-jp%40#{version}ibm-plex-sans-jp.zip"
  name "IBM Plex Sans JP"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-jp@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Bold.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-ExtraLight.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Light.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Medium.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Regular.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-SemiBold.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Text.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Thin.otf"

  # No zap stanza required
end