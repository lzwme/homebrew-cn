cask "focu" do
  version "0.12.2"
  sha256 "190b6f61158d3c35a60df4847c9f6f43dfa60c3c67e5fb3947170a67d006d6da"

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