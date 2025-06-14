cask "cloudpouch" do
  version "1.40.0"
  sha256 "fc209399ac6d5899089b835542c9ecc7da26d54ae0c3046802a6ca7497fd73ee"

  url "https:github.comCloudPouchCloudPouch.devreleasesdownloadv#{version}CloudPouch-#{version}-universal-mac.zip",
      verified: "github.comCloudPouchCloudPouch.dev"
  name "CloudPouch"
  desc "AWS cloud FinOps tool"
  homepage "https:cloudpouch.dev"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "CloudPouch.app"

  zap trash: [
    "~.cloudpouch-aws-sso-client-credentials",
    "~LibraryApplication SupportCloudPouch",
    "~LibraryLogsCloudPouch",
  ]
end