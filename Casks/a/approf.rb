cask "approf" do
  version "14.1.2"
  sha256 "82d0850f1cd7d2e7429650ef99f4ea9bd42dff23f3fed0ea7ec221d0dde3d52e"

  url "https:github.commoderato-appapprofreleasesdownloadv#{version}approf-#{version}.app.zip"
  name "approf"
  desc "Native app for pprof"
  homepage "https:github.commoderato-appapprof"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "approf.app"

  uninstall quit: "the.future.app.approf.approf"

  zap trash: [
    "~LibraryApplication Supportthe.future.app.approf.approf.plist",
    "~LibraryCachesthe.future.app.approf.approf",
    "~LibraryCookiesthe.future.app.approf.approf.binarycookies",
    "~LibraryHTTPStoragesthe.future.app.approf.approf",
    "~LibraryLaunchAgentsthe.future.app.approf.approf.plist",
    "~LibraryPreferencesthe.future.app.approf.approf.plist",
  ]
end