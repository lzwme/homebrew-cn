cask "webviewscreensaver" do
  version "2.4"
  sha256 "08467e5723b167c3f0ad93db9757048ccb3e9d5ef34f00fcfb9435360191c5b1"

  url "https:github.comliquidxwebviewscreensaverreleasesdownloadv#{version}WebViewScreenSaver-#{version}.zip"
  name "WebViewScreenSaver"
  desc "Screen saver that displays web pages"
  homepage "https:github.comliquidxwebviewscreensaver"

  livecheck do
    url :url
    strategy :github_latest
  end

  screen_saver "WebViewScreenSaver.saver"

  zap trash: [
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryPreferencesByHostWebViewScreenSaver.*",
    "~LibraryPreferencesByHostWebViewScreenSaver.*",
    "~LibraryScreen SaversWebViewScreenSaver.saver",
  ]
end