cask "swama" do
  version "1.3.0"
  sha256 "2a638eb493c888deae6ee4190a67eb2ba9b3e29f1c8877b38b1681f72fb29076"

  url "https:github.comTrans-N-aiswamareleasesdownloadv#{version}Swama.dmg"
  name "Swama"
  desc "Machine-learning runtime"
  homepage "https:github.comTrans-N-aiswama"

  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "Swama.app"

  zap trash: "~LibraryPreferencestrans-n.ai.Swama.plist"
end