cask "bluewallet" do
  version "7.1.8"
  sha256 "ff87d5ddc8988fa9efd8952881b9785b07773705f1c41e32df4f793ba3bceb97"

  url "https:github.comBlueWalletBlueWalletreleasesdownloadv#{version}BlueWallet.#{version}.dmg",
      verified: "github.comBlueWalletBlueWallet"
  name "BlueWallet"
  desc "Bitcoin wallet and Lightning wallet"
  homepage "https:bluewallet.io"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^BlueWallet[._-]v?(\d+(?:\.\d+)+)\.dmg$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  depends_on macos: ">= :big_sur"

  app "BlueWallet.app"

  zap trash: [
    "~LibraryApplication Scriptsio.bluewallet.bluewallet",
    "~LibraryContainersio.bluewallet.bluewallet",
    "~LibraryGroup Containersgroup.io.bluewallet.bluewallet",
  ]
end