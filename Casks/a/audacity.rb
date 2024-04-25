cask "audacity" do
  arch arm: "arm64", intel: "x86_64"

  version "3.5.1"
  sha256 arm:   "7f80a8a5ffed98a01b5f0c8a7ee57331bdabbd7812d9a944c25f350a1b28c633",
         intel: "e89b17ed5236c11fdf85100b5bd7867632b318dd1acc90ca45c32a564d43d217"

  url "https:github.comaudacityaudacityreleasesdownloadAudacity-#{version}audacity-macOS-#{version}-#{arch}.dmg",
      verified: "github.comaudacityaudacity"
  name "Audacity"
  desc "Multi-track audio editor and recorder"
  homepage "https:www.audacityteam.org"

  livecheck do
    url :url
    regex(^Audacity[._-]v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :high_sierra"

  app "Audacity.app"

  zap trash: [
    "~LibraryApplication Supportaudacity",
    "~LibraryPreferencesorg.audacityteam.audacity.plist",
    "~LibrarySaved Application Stateorg.audacityteam.audacity.savedState",
  ]
end