cask "fly" do
  version "7.13.1"
  sha256 "62b4112101e8ec98bba1f822d1c4818ef44807709bbf3070a791aeaa62f5e2ec"

  url "https:github.comconcourseconcoursereleasesdownloadv#{version}fly-#{version}-darwin-amd64.tgz"
  name "fly"
  desc "Official CLI tool for Concourse CI"
  homepage "https:github.comconcourseconcourse"

  binary "fly"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end