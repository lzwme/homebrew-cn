cask "font-migu-2m" do
  version "2023.1123"
  sha256 "e7845f148772c984064c325eba70ed4dfb9a27084c2011a3a1b6194be6e439e5"

  url "https:github.comitouhiromixfont-mplus-ipareleasesdownloadv#{version}migu-2m-#{version.no_dots}.zip",
      verified: "github.comitouhiromixfont-mplus-ipa"
  name "Migu 2M"
  homepage "https:itouhiro.github.iomixfont-mplus-ipamigu"

  livecheck do
    url :homepage
    regex(%r{href=.*?downloadv?(\d+(?:\.\d+)+)migu-2m[._-]}i)
  end

  no_autobump! because: :requires_manual_review

  font "migu-2m-#{version.no_dots}migu-2m-bold.ttf"
  font "migu-2m-#{version.no_dots}migu-2m-regular.ttf"

  # No zap stanza required
end