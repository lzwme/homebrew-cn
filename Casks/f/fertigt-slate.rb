cask "fertigt-slate" do
  version "1.0"
  sha256 "30a6e20b4136569accab9f38d8659193726d984ef6235b035db59e678deec7bf"

  url "https:github.comfertigtslate_arm64releasesdownload#{version}Slate.zip"
  name "Slate (arm64)"
  desc "Window management application"
  homepage "https:github.comfertigtslate_arm64"

  no_autobump! because: :requires_manual_review

  app "Slate.app"

  zap trash: [
    "~.slate",
    "~.slate.js",
    "~LibraryApplication Supportcom.tobiasfertig.Slate",
  ]
end