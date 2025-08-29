cask "cork" do
  version "1.5.7"
  sha256 "90175e2c820f0d9497600b5f344afacd47182c0308d18312f5a6b04b5d3af847"

  url "https://corkmac.app/RLS/#{version}/Cork.zip"
  name "Cork"
  desc "GUI companion app for Homebrew"
  homepage "https://www.corkmac.app/"

  livecheck do
    url "https://corkmac.app/RLS/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  depends_on macos: ">= :ventura"

  app "Cork.app"

  zap trash: [
    "~/Documents/Cork",
    "~/Library/Caches/com.davidbures.cork",
    "~/Library/HTTPStorages/com.davidbures.cork",
    "~/Library/Preferences/com.davidbures.cork.plist",
    "~/Library/Saved Application State/com.davidbures.cork.savedState",
  ]
end