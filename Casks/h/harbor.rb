cask "harbor" do
  version "0.1.2"
  sha256 "3330b8f76fd7c4e495e8b9ce2e929157b10c3686a33e403478b5f5947aac2b0b"

  url "https:github.commadeintandemharborreleasesdownloadv#{version}Harbor.app.zip"
  name "Harbor"
  desc "Tool to monitor Codeship builds from the status bar"
  homepage "https:github.commadeintandemharbor"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-03-05", because: :unmaintained
  disable! date: "2025-03-05", because: :unmaintained

  app "Harbor.app"
end