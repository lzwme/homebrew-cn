cask "impactor" do
  version "2.1.0"
  sha256 "fefc389b61ecf12ee352632270dd6eb7b8d039badecec5c81d19447fcc647af9"

  url "https://ghfast.top/https://github.com/khcrysalis/Impactor/releases/download/v#{version}/Impactor-macos-universal.dmg"
  name "Impactor"
  desc "Sideloading application for iOS/tvOS"
  homepage "https://github.com/khcrysalis/Impactor/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Impactor.app"

  zap trash: "~/.config/PlumeImpactor"
end