cask "tablepro" do
  arch arm: "arm64", intel: "x86_64"

  version "0.39.1"
  sha256 arm:   "dfea06417fe9db88922531e2fd9d8d12d14435152bbcffc4b45fe848cff0fa26",
         intel: "d074dd45b7f83f2425ddbd27c8aae37434410f29cfc318c78a39d8ec4266cd76"

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