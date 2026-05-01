cask "spectrolite" do
  arch arm: "arm64", intel: "x64"

  version "1.4.4"
  sha256 arm:   "4181d4115a8896f15243c02f97e3dcf9cac569aef6170af22905148f3def1b36",
         intel: "6c194bccb3e442dd66bea941c6350a78b43457319116415ae0b9206fd1792a9d"

  url "https://spectrolite.app/downloads/Spectrolite-#{version}-#{arch}.zip"
  name "Spectrolite"
  desc "App for making risograph prints"
  homepage "https://spectrolite.app/"

  livecheck do
    url "https://d398dq9v5f85fz.cloudfront.net/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on :macos

  app "Spectrolite.app"

  zap trash: [
    "~/Library/Application Support/spectrolite",
    "~/Library/Logs/Spectrolite",
    "~/Library/Preferences/com.electron.spectrolite.plist",
    "~/Library/Saved Application State/com.electron.spectrolite.savedState",
  ]
end