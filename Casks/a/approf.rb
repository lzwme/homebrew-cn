cask "approf" do
  version "14.1.3"
  sha256 "cc6317df3877668b94d88643ae57b974e30c713ff2593e4f8d7755c9f58f28c2"

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