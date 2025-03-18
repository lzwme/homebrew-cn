cask "ui-tars" do
  arch arm: "arm64", intel: "x64"

  version "0.0.7"
  sha256 arm:   "e3f234189589f8633e02a1ffd94f12e19fa63cd24c6fe98d8e0898c0a8c20489",
         intel: "a21df8d2145e7d074e79892ecd1f34ab1bf760974522f46993bd7fe72a9d5797"

  url "https:github.combytedanceUI-TARS-desktopreleasesdownloadv#{version}UI.TARS-#{version}-#{arch}.dmg"
  name "UI-TARS Desktop"
  desc "GUI Agent for computer control using UI-TARS vision-language model"
  homepage "https:github.combytedanceUI-TARS-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "UI TARS.app"

  uninstall quit: "com.bytedance.uitars"

  zap trash: [
    "~LibraryApplication Supportui-tars-desktop",
    "~LibraryLogsui-tars-desktop",
  ]
end