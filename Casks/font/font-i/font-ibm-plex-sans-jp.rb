cask "font-ibm-plex-sans-jp" do
  version "2.0.0"
  sha256 "ce6af1c716bfe24d2f8129129e4fea8cd4b573869d8417ec4f22eab1e07da510"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-jp%40#{version}ibm-plex-sans-jp.zip"
  name "IBM Plex Sans JP"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-jp@?(\d+(?:\.\d+)+)$}i)
  end

  no_autobump! because: :requires_manual_review

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