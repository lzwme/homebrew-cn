cask "sidebarfavorites-manager" do
  version "1.3.1"
  sha256 "f33115d32c17be8f89dc6e7bb7b0d3f595161500fb58b1225e3576b9605cb6f3"

  url "https://ghfast.top/https://github.com/ivg-design/SidebarFavorites/releases/download/v#{version}/SidebarFavorites-#{version}.dmg"
  name "SidebarFavorites Manager"
  desc "Finder sidebar icon customiser"
  homepage "https://github.com/ivg-design/SidebarFavorites"

  depends_on macos: :ventura

  app "SidebarFavorites Manager.app"

  uninstall quit: "com.ivg-design.SidebarFavoritesManager"

  zap trash: [
    "~/Library/Application Scripts/com.ivg-design.SidebarFavorites.*",
    "~/Library/Application Support/SidebarFavorites",
    "~/Library/Caches/com.ivg-design.SidebarFavoritesManager",
    "~/Library/Containers/com.ivg-design.SidebarFavorites.*",
    "~/Library/HTTPStorages/com.ivg-design.SidebarFavoritesManager",
    "~/Library/Preferences/com.ivg-design.SidebarFavoritesManager.plist",
    "~/Library/Saved Application State/com.ivg-design.SidebarFavoritesManager.savedState",
  ]
end