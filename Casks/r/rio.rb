cask "rio" do
  version "0.2.30"
  sha256 "699cfca5a7714c52a15289ca7151a097fb83607ddca48054fdfcc3aff9cc949c"

  url "https://ghfast.top/https://github.com/raphamorim/rio/releases/download/v#{version}/rio.dmg"
  name "Rio"
  desc "Hardware-accelerated GPU terminal emulator"
  homepage "https://github.com/raphamorim/rio/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "rio.app"
  binary "#{appdir}/rio.app/Contents/MacOS/rio"
  binary "#{appdir}/rio.app/Contents/Resources/72/rio",
         target: "#{ENV.fetch("TERMINFO", "~/.terminfo")}/72/rio"

  zap trash: "~/Library/Saved Application State/com.raphaelamorim.rio.savedState"
end