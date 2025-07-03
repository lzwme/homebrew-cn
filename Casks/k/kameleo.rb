cask "kameleo" do
  version "4.1.0"
  sha256 "33c13e894e1425823ebf1754efbc548a2f0ecce9e6dff4ad97d34cb347e65e8e"

  url "https:github.comkameleo-ioreleasesreleasesdownload#{version}kameleo-#{version}-osx-arm64.dmg",
      verified: "github.comkameleo-ioreleases"
  name "Kameleo"
  desc "Antidetect browser to bypass anti-bot systems"
  homepage "https:kameleo.io"

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"

  app "Kameleo.app"

  zap trash: "~LibraryApplication SupportKameleo"
end