cask "fly" do
  version "7.11.0"
  sha256 "823ecc4c562bfd5a6fb1385a17ef3c6011232787ab2a40dd0c7e4f331970c94f"

  url "https:github.comconcourseconcoursereleasesdownloadv#{version}fly-#{version}-darwin-amd64.tgz"
  name "fly"
  desc "Official CLI tool for Concourse CI"
  homepage "https:github.comconcourseconcourse"

  binary "fly"

  # No zap stanza required
end