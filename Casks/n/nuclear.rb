cask "nuclear" do
  version "0.6.30"
  sha256 "206daca8686562def115c969209ac13700138f918fa82dedb3a0f1eb8b1c1935"

  url "https:github.comnukeopnuclearreleasesdownloadv#{version}nuclear-v#{version}.dmg",
      verified: "github.comnukeopnuclear"
  name "Nuclear"
  desc "Streaming music player"
  homepage "https:nuclear.js.org"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)+)i)
  end

  app "nuclear.app"

  zap trash: [
    "~LibraryApplication Supportnuclear",
    "~LibraryLogsnuclear",
    "~LibraryPreferencesnuclear.plist",
    "~LibrarySaved Application Statenuclear.savedState",
  ]

  caveats do
    requires_rosetta
  end
end