cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.12.3"
  sha256 arm:   "12bb8e20c6cb4b5d83de7de14bf03e874a065a41bd12dcb7114d58438f9fd6bb",
         intel: "da26733f848e96e4d06e58207d21fe8b4ef02272595be4d7fbc49f382a4d82b8"

  url "https:github.comChilledheartyassreleasesdownload#{version}yass-macos-release#{arch}-#{version}.dmg"
  name "Yet Another Shadow Socket"
  desc "Lightweight and efficient, sockshttp forward proxy"
  homepage "https:github.comChilledheartyass"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "yass.app"
  binary "#{appdir}yass.appContentsMacOSyass"

  zap trash: [
    "~LibraryPreferencesit.gui.yass.plist",
    "~LibraryPreferencesit.gui.yass.suite.plist",
  ]
end