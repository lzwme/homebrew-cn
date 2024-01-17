cask "osquery" do
  version "5.11.0"
  sha256 "7d0f97d0d4b463fcf03abedbf58939c900f310c214fd2fa3c28b1a848dcbffd9"

  url "https:github.comosqueryosqueryreleasesdownload#{version}osquery-#{version}.pkg",
      verified: "github.comosqueryosquery"
  name "osquery"
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https:osquery.io"

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