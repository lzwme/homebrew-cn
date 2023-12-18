cask "keeweb" do
  arch arm: "arm64", intel: "x64"

  version "1.18.7"
  sha256 arm:   "6e4870b1660b91e735eaf30e7d751c7bb8dfae623d5b6c47899bd4d5ab1e6cae",
         intel: "f99146aebc34b59ec5ea56ffde2048c860feb69d69b958643efd7485fa7a0135"

  url "https:github.comkeewebkeewebreleasesdownloadv#{version}KeeWeb-#{version}.mac.#{arch}.dmg",
      verified: "github.comkeewebkeeweb"
  name "KeeWeb"
  desc "Password manager compatible with KeePass"
  homepage "https:keeweb.info"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "KeeWeb.app"

  uninstall_preflight do
    set_ownership "#{appdir}KeeWeb.app"
  end

  zap trash: [
    "~LibraryApplication SupportKeeWeb",
    "~LibraryPreferencesnet.antelle.keeweb.plist",
    "~LibrarySaved Application Statenet.antelle.keeweb.savedState",
  ]
end