cask "cadran" do
  version "1.3.7"
  sha256 "a14f97ff893a0923ddbc97678f0dfd44f2330b93546fb42ae5e83b93e3000444"

  url "https://ghfast.top/https://github.com/Ilyomix/Cadran-releases/releases/download/v#{version}/Cadran-#{version}.dmg",
      verified: "github.com/Ilyomix/Cadran-releases/"
  name "Cadran"
  desc "Desktop clock rendered behind your icons"
  homepage "https://cadranapp.com/"

  livecheck do
    url "https://github.com/Ilyomix/Cadran-releases/releases/latest/download/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Cadran.app"

  zap trash: [
    "~/Library/Application Support/Cadran",
    "~/Library/Preferences/ilyomix.Cadran.plist",
  ]
end