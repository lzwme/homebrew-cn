cask "font-ibm-plex-sans-thai" do
  version "1.0.0"
  sha256 "1a39b37654916260791073046aa811450fd9bea63c2acb4413546636939c43a1"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-thai%40#{version}ibm-plex-sans-thai.zip"
  name "IBM Plex Sans Thai"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-thai@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-thaifontscompleteotfIBMPlexSansThai-Bold.otf"
  font "ibm-plex-sans-thaifontscompleteotfIBMPlexSansThai-ExtraLight.otf"
  font "ibm-plex-sans-thaifontscompleteotfIBMPlexSansThai-Light.otf"
  font "ibm-plex-sans-thaifontscompleteotfIBMPlexSansThai-Medium.otf"
  font "ibm-plex-sans-thaifontscompleteotfIBMPlexSansThai-Regular.otf"
  font "ibm-plex-sans-thaifontscompleteotfIBMPlexSansThai-SemiBold.otf"
  font "ibm-plex-sans-thaifontscompleteotfIBMPlexSansThai-Text.otf"
  font "ibm-plex-sans-thaifontscompleteotfIBMPlexSansThai-Thin.otf"

  # No zap stanza required
end