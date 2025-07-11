cask "warsow" do
  version "2.1.2"
  sha256 "176b037186e4d8a1c0fc740fe8660cd960339fc4eeca5e5eaaec4028b9bd6aba"

  url "https://warsow.net/warsow-#{version}.dmg"
  name "Warsow"
  desc "First-person shooter game"
  homepage "https://www.warsow.net/"

  livecheck do
    url "https://www.warsow.net/bundles/client.bundle.js"
    regex(%r{href=.*?/warsow-(\d+(?:\.\d+)*)\.dmg}i)
  end

  no_autobump! because: :requires_manual_review

  app "Warsow.app"

  zap trash: [
    "~/Library/Application Support/Warsow-#{version.major_minor}",
    "~/Library/Caches/Warsow-#{version.major_minor}",
    "~/Library/Saved Application State/org.picmip.Warsow.savedState",
  ]

  caveats do
    requires_rosetta
  end
end