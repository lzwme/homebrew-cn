cask "cloudpouch" do
  version "1.41.0"
  sha256 "b75a9a2eb0d3a8061babc1b1a8f7bc52e423a7100e4fcb89818ad3d813535c4c"

  url "https:github.comCloudPouchCloudPouch.devreleasesdownloadv#{version}CloudPouch-#{version}-universal-mac.zip",
      verified: "github.comCloudPouchCloudPouch.dev"
  name "CloudPouch"
  desc "AWS cloud FinOps tool"
  homepage "https:cloudpouch.dev"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "CloudPouch.app"

  zap trash: [
    "~.cloudpouch-aws-sso-client-credentials",
    "~LibraryApplication SupportCloudPouch",
    "~LibraryLogsCloudPouch",
  ]
end