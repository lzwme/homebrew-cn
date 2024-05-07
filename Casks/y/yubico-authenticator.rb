cask "yubico-authenticator" do
  version "7.0.0"
  sha256 "ea9e07d5f3ada7d75c1555de42b93a6d91ccc4dab0460520a3ddd9ac7be80bf1"

  url "https:github.comYubicoyubioath-flutterreleasesdownload#{version}yubico-authenticator-#{version}-mac.dmg",
      verified: "github.comYubicoyubioath-flutterreleasesdownload"
  name "Yubico Authenticator"
  desc "Application for generating TOTP and HOTP codes"
  homepage "https:developers.yubico.comyubioath-flutter"

  depends_on macos: ">= :big_sur"

  app "Yubico Authenticator.app"

  zap trash: [
    "~LibraryApplication Scriptscom.yubico.authenticator",
    "~LibraryContainerscom.yubico.authenticator",
  ]
end