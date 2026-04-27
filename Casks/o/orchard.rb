cask "orchard" do
  version "1.11.7"
  sha256 "0da5ef2c71e6704ea13418bae992db16716c8e1d1acbb043a4aed16110fe6ff8"

  url "https://ghfast.top/https://github.com/andrew-waters/orchard/releases/download/v#{version}/Orchard-#{version}.dmg"
  name "Orchard"
  desc "Native GUI for Apple Containers"
  homepage "https://github.com/andrew-waters/orchard"

  depends_on macos: ">= :tahoe"

  app "Orchard.app"

  zap trash: [
    "~/Library/Caches/container-compose.Orchard",
    "~/Library/Preferences/container-compose.Orchard.plist",
  ]
end