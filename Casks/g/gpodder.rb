cask "gpodder" do
  version "3.11.5"
  sha256 "ecef8bd8eb8122a3adb28ecd4d06bfccc6b07cf41352ab9190c11c9978554c06"

  url "https://ghfast.top/https://github.com/gpodder/gpodder/releases/download/#{version}/macOS-gPodder-#{version}.zip",
      verified: "github.com/gpodder/gpodder/"
  name "gPodder"
  desc "Podcast client"
  homepage "https://gpodder.github.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :unsigned

  app "gPodder.app"

  zap trash: "~/Library/Application Support/gPodder"

  caveats do
    requires_rosetta
  end
end