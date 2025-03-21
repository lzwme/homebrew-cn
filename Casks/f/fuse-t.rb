cask "fuse-t" do
  version "1.0.47"
  sha256 "b0121b5f92bd22f26206ed2aee8fbcb8c410ba2791fd30884faad2f2ec0407f3"

  url "https:github.commacos-fuse-tfuse-treleasesdownload#{version}fuse-t-macos-installer-#{version}.pkg",
      verified: "github.commacos-fuse-tfuse-t"
  name "FUSE-T"
  desc "Kext-less implementation of FUSE"
  homepage "https:www.fuse-t.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "fuse-t-macos-installer-#{version}.pkg"

  uninstall script: {
    executable: "LibraryApplication Supportfuse-tuninstall.sh",
    input:      ["Y"],
    sudo:       true,
  }

  # No zap stanza required
end