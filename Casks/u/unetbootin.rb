cask "unetbootin" do
  version "702"
  sha256 "204f867e9b2604a5ba8818b7d7f4be83d08fa0c3eb0c22e51c39fc5526bd1aed"

  url "https:github.comunetbootinunetbootinreleasesdownload#{version}unetbootin-mac-#{version}.dmg",
      verified: "github.comunetbootinunetbootin"
  name "UNetbootin"
  desc "Tool to install LinuxBSD distributions to a partition or USB drive"
  homepage "https:unetbootin.github.io"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)*)$i)
  end

  app "unetbootin.app"

  zap trash: "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.yourcompany.unetbootin.sfl*"
end