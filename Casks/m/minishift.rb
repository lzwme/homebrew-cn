cask "minishift" do
  version "1.34.3"
  sha256 "3e80aa7987ae3440d15fbd529311a574ad1fa5cee77cff35d64d85e011ce1128"

  url "https:github.comminishiftminishiftreleasesdownloadv#{version}minishift-#{version}-darwin-amd64.tgz"
  name "Minishift"
  homepage "https:github.comminishiftminishift"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2020-09-26", because: :unmaintained
  disable! date: "2025-06-26", because: :unmaintained

  binary "minishift-#{version}-darwin-amd64minishift"

  zap trash: "~.minishift"

  caveats do
    requires_rosetta
  end
end