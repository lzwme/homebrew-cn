cask "swama" do
  version "1.4.0"
  sha256 "b82f325a024e85ae46bbdfed32ad97fa3a6fde58a7bbbf16d1ba5412c6e9e702"

  url "https:github.comTrans-N-aiswamareleasesdownloadv#{version}Swama.dmg"
  name "Swama"
  desc "Machine-learning runtime"
  homepage "https:github.comTrans-N-aiswama"

  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "Swama.app"

  zap trash: "~LibraryPreferencestrans-n.ai.Swama.plist"
end