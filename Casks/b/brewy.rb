cask "brewy" do
  version "0.8.0"
  sha256 "8e8ec3d9a29f1235deebd4cfefbcd85500de9c16e57866162ea2f1fdaef52e9a"

  url "https://ghfast.top/https://github.com/p-linnane/Brewy/releases/download/#{version}/Brewy-#{version}.zip"
  name "Brewy"
  desc "Simple Homebrew GUI"
  homepage "https://github.com/p-linnane/Brewy"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/p-linnane/Brewy/appcast/appcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :bumped_by_upstream

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :sequoia"

  app "Brewy.app"

  zap trash: [
    "~/Library/Application Scripts/io.linnane.Brewy",
    "~/Library/Application Support/Brewy",
    "~/Library/Caches/io.linnane.brewy",
    "~/Library/Containers/io.linnane.Brewy",
    "~/Library/HTTPStorages/io.linnane.brewy",
    "~/Library/Preferences/Brewy.plist",
    "~/Library/Preferences/io.linnane.brewy.plist",
    "~/Library/WebKit/io.linnane.brewy",
  ]
end