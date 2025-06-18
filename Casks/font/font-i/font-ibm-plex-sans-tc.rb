cask "font-ibm-plex-sans-tc" do
  version "1.1.1"
  sha256 "b79600d3c9155fa05c9024eb81cfe2fbdd8cd068503dfafd79405ea577aa9fec"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-tc%40#{version}ibm-plex-sans-tc.zip"
  name "IBM Plex Sans TC"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-tc@?(\d+(?:\.\d+)+)$}i)
  end

  no_autobump! because: :requires_manual_review

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