cask "ui-tars" do
  version "0.0.9"
  sha256 "e46d05e6e9f172e624a1b2623597b1c3ee843e339a8ed5b8f5f4d3d186681738"

  url "https:github.combytedanceUI-TARS-desktopreleasesdownloadv#{version}UI.TARS-#{version}-universal.dmg"
  name "UI-TARS Desktop"
  desc "GUI Agent for computer control using UI-TARS vision-language model"
  homepage "https:github.combytedanceUI-TARS-desktop"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
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