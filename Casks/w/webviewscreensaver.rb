cask "webviewscreensaver" do
  version "2.2.1"
  sha256 "c2ad54d7dbe1a08d36d867ff21eb853bc083459d1b80ec78589ada5c8db86939"

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
    "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryPreferences" \
    "ByHostWebViewScreenSaver.*",
    "~LibraryPreferencesByHostWebViewScreenSaver.*",
    "~LibraryScreen SaversWebViewScreenSaver.saver",
  ]
end