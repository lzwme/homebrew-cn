cask "tablepro" do
  arch arm: "arm64", intel: "x86_64"

  version "0.37.0"
  sha256 arm:   "9cc933a49214e3c36e1b38da8d2f108991e34a2375fc96deb41e8ef552d788df",
         intel: "1c3677822b7041449e30f6f47e6e9895101cce1563280a744b1457f6cedb2707"

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