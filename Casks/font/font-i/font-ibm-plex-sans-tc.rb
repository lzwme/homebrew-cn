cask "font-ibm-plex-sans-tc" do
  version "1.0.0"
  sha256 "38f4b86e52b5735eb926b6a0a41293ace6708632e41a0280618939d601dd5aaf"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-tc%40#{version}ibm-plex-sans-tc.zip"
  name "IBM Plex Sans TC"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-tc@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-tcfontscompleteotfhintedIBMPlexSansTC-Bold.otf"
  font "ibm-plex-sans-tcfontscompleteotfhintedIBMPlexSansTC-ExtraLight.otf"
  font "ibm-plex-sans-tcfontscompleteotfhintedIBMPlexSansTC-Light.otf"
  font "ibm-plex-sans-tcfontscompleteotfhintedIBMPlexSansTC-Medium.otf"
  font "ibm-plex-sans-tcfontscompleteotfhintedIBMPlexSansTC-Regular.otf"
  font "ibm-plex-sans-tcfontscompleteotfhintedIBMPlexSansTC-SemiBold.otf"
  font "ibm-plex-sans-tcfontscompleteotfhintedIBMPlexSansTC-Text.otf"
  font "ibm-plex-sans-tcfontscompleteotfhintedIBMPlexSansTC-Thin.otf"

  # No zap stanza required
end