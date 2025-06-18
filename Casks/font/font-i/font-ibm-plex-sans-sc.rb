cask "font-ibm-plex-sans-sc" do
  version "1.1.0"
  sha256 "0aabd737c8ef0206892b912c759101c10b86c6244be99f2e6b57c6905c716837"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-sc%40#{version}ibm-plex-sans-sc.zip"
  name "IBM Plex Sans SC"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-sc@?(\d+(?:\.\d+)+)$}i)
  end

  no_autobump! because: :requires_manual_review

  font "ibm-plex-sans-scfontscompleteotfhintedIBMPlexSansSC-Bold.otf"
  font "ibm-plex-sans-scfontscompleteotfhintedIBMPlexSansSC-ExtraLight.otf"
  font "ibm-plex-sans-scfontscompleteotfhintedIBMPlexSansSC-Light.otf"
  font "ibm-plex-sans-scfontscompleteotfhintedIBMPlexSansSC-Medium.otf"
  font "ibm-plex-sans-scfontscompleteotfhintedIBMPlexSansSC-Regular.otf"
  font "ibm-plex-sans-scfontscompleteotfhintedIBMPlexSansSC-SemiBold.otf"
  font "ibm-plex-sans-scfontscompleteotfhintedIBMPlexSansSC-Text.otf"
  font "ibm-plex-sans-scfontscompleteotfhintedIBMPlexSansSC-Thin.otf"

  # No zap stanza required
end