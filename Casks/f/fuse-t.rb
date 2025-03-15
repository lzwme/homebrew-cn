cask "fuse-t" do
  version "1.0.46"
  sha256 "8616487e1b442ebd22078cdc09925714826ded028d851dcd8c78b15f2d7e42d2"

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