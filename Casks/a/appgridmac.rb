cask "appgridmac" do
  version "1.1.13"
  sha256 "f7e9a6f92f79d9d1536d34538050b3aa0c738120f64ccbf6a80da354982c6e1e"

  url "https://zekalogic.com/appgrid/app/AppGridMac-#{version}.zip",
      verified: "zekalogic.com/appgrid/app/"
  name "AppGridMac"
  desc "AI-assisted Launchpad replacement"
  homepage "https://appgridmac.com/"

  livecheck do
    url "https://zekalogic.com/appgrid/app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :sonoma"

  app "AppGridMac.app"

  zap trash: [
    "~/Library/Application Support/com.zekalogic.appgrid.app.direct",
    "~/Library/Preferences/com.zekalogic.appgrid.app.direct.plist",
    "~/Library/Saved Application State/com.zekalogic.appgrid.app.direct.savedState",
  ]
end