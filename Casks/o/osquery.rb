cask "osquery" do
  version "5.18.1"
  sha256 "fa0c035be9456ced1f8b7267f209ca1ea3cf217074fec295d1b11e551cba3195"

  url "https://ghfast.top/https://github.com/osquery/osquery/releases/download/#{version}/osquery-#{version}.pkg",
      verified: "github.com/osquery/osquery/"
  name "osquery"
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "osquery-#{version}.pkg"

  uninstall launchctl: "com.facebook.osqueryd",
            pkgutil:   [
              "com.facebook.osquery",
              "io.osquery.agent",
            ]

  # No zap stanza required
end