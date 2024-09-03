cask "font-ibm-plex-math" do
  version "1.0.0"
  sha256 "3a4f0beec798d1b3300f0d31f1bd9772ebaf284eaf9fc09187d87606b3cf56a6"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-math%40#{version}ibm-plex-math.zip"
  name "IBM Plex Math"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-math@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-mathfontscompleteotfIBMPlexMath-Regular.otf"

  # No zap stanza required
end