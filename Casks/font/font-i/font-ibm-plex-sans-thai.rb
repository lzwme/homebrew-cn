cask "font-ibm-plex-sans-thai" do
  version "1.1.0"
  sha256 "d7203f43c20f9abd40487f845c48db4077d2056ea18632c8959591c6815d7fb9"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-thai%40#{version}ibm-plex-sans-thai.zip"
  name "IBM Plex Sans Thai"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-thai@?(\d+(?:\.\d+)+)$}i)
  end

  no_autobump! because: :requires_manual_review

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