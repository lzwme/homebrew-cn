cask "mcedit" do
  version "1.5.6.0"
  sha256 "e2026de3589e3e65086a385ee4e02d607337bc9da11357d1b3ac106e2ee843d7"

  url "https:github.comPodshotMCEdit-Unifiedreleasesdownload#{version}MCEdit.v#{version}.OSX.64bit.zip",
      verified: "github.comPodshotMCEdit-Unified"
  name "MCEdit-Unified"
  desc "Minecraft world editor"
  homepage "https:www.mcedit-unified.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "mcedit.app"
end