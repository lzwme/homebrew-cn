cask "tablepro" do
  arch arm: "arm64", intel: "x86_64"

  version "0.36.0"
  sha256 arm:   "a21a1f070fe9fef79395834c8eebb402df257a30c446e0b8be5f761d1e400fc8",
         intel: "9e70922f80f2ca7c0f3568c4631d10e3bd66d9accc75ad9894e433ab093ac412"

  url "https://ghfast.top/https://github.com/TableProApp/TablePro/releases/download/v#{version}/TablePro-#{version}-#{arch}.dmg",
      verified: "github.com/TableProApp/TablePro/"
  name "TablePro"
  desc "Native database client for many database types"
  homepage "https://tablepro.app/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/TableProApp/TablePro/main/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "TablePro.app"

  zap trash: [
    "~/Library/Application Support/TablePro",
    "~/Library/Caches/com.TablePro",
    "~/Library/HTTPStorages/com.TablePro",
    "~/Library/Preferences/com.TablePro.plist",
  ]
end