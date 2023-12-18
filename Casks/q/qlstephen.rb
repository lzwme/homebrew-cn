cask "qlstephen" do
  version "1.5.1"
  sha256 "1f4a6104687d8c6479316dea37a88eb1a94875b0814744b9dc307492eb259c04"

  url "https:github.comwhomwahqlstephenreleasesdownload#{version}QLStephen.qlgenerator.#{version}.zip",
      verified: "github.comwhomwahqlstephen"
  name "QLStephen"
  desc "QuickLook plugin for plaintext files without an extension"
  homepage "https:whomwah.github.ioqlstephen"

  qlplugin "QLStephen.qlgenerator"

  # No zap stanza required
end