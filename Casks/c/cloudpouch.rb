cask "cloudpouch" do
  version "1.39.0"
  sha256 "a0b67288849b8ecf4056894d7c4592fbd13daf699275fb1b4ecb6a2d21661b1c"

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