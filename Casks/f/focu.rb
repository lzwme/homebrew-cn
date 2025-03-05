cask "focu" do
  version "0.12.0"
  sha256 "887d8f30c7c416092fac5572c645cdf40a0bbe0d1e0edf7fbee738eb190da354"

  url "https:github.comfocu-appfocu-appreleasesdownloadv#{version}Focu_#{version}_aarch64.dmg",
      verified: "github.comfocu-appfocu-app"
  name "Focu"
  desc "Mindful productivity app"
  homepage "https:focu.app"

  livecheck do
    url "https:focu.appapilatest-release"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"
  depends_on arch: :arm64

  app "Focu.app"

  uninstall quit: "app.focu.Focu"

  zap trash: [
        "~DocumentsFocubackups",
        "~LibraryApplication Supportapp.focu.Focu",
        "~LibraryCachesapp.focu.Focu",
        "~LibraryWebKitapp.focu.Focu",
      ],
      rmdir: "~DocumentsFocu"
end