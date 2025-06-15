cask "listen1" do
  # NOTE: "1" is not a version number, but an intrinsic part of the product name
  arch arm: "arm64", intel: "x64"

  version "2.32.0"
  sha256 arm:   "9bcc4b7a3d794165e53a95b1c65c9d9dcd1d751e2ee5992b56b8347adfb26b52",
         intel: "3519edb3e7bb3711e271bac9d809f4ef3a73ebed58eff84edb47fba401fe48ea"

  url "https:github.comlisten1listen1_desktopreleasesdownloadv#{version}Listen1_#{version}_mac_#{arch}.dmg",
      verified: "github.comlisten1listen1_desktop"
  name "Listen 1"
  desc "Search and play songs from a variety of online sources"
  homepage "https:listen1.github.iolisten1"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :el_capitan"

  app "Listen1.app"

  zap trash: [
    "~LibraryApplication Supportlisten1",
    "~LibraryPreferencescom.listen1.listen1.plist",
  ]
end