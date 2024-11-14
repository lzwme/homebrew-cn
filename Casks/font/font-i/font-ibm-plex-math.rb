cask "font-ibm-plex-math" do
  version "1.1.0"
  sha256 "d85ed404394ced3a79a519af24611acdee9cc0483363c07cd5ac0656c06db42a"

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