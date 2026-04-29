cask "thebrowsercompany-dia" do
  version "1.28.1,79847"
  sha256 "e7cf167e8b7de7422b041c11b3ae41300a068462997f18605f7d801b5bf88f30"

  url "https://releases.diabrowser.com/release/Dia-#{version.tr(",", "-")}.zip"
  name "Dia"
  desc "Web browser"
  homepage "https://www.diabrowser.com/"

  livecheck do
    url "https://releases.diabrowser.com/BoostBrowser-updates.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "Dia.app"

  zap trash: [
    "~/Library/Application Support/Dia",
    "~/Library/Caches/company.thebrowser.dia",
    "~/Library/HttpStorages/company.thebrowser.dia",
    "~/Library/HttpStorages/company.thebrowser.dia.binarycookies",
    "~/Library/Preferences/company.thebrowser.dia.plist",
  ]
end