cask "gpodder" do
  version "3.11.5"
  sha256 "ecef8bd8eb8122a3adb28ecd4d06bfccc6b07cf41352ab9190c11c9978554c06"

  url "https:github.comgpoddergpodderreleasesdownload#{version}macOS-gPodder-#{version}.zip",
      verified: "github.comgpoddergpodder"
  name "gPodder"
  desc "Podcast client"
  homepage "https:gpodder.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "gPodder.app"

  zap trash: "~LibraryApplication SupportgPodder"

  caveats do
    requires_rosetta
  end
end