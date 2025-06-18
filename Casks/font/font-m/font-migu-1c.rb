cask "font-migu-1c" do
  version "2020.0307"
  sha256 "de18e4558495ab2860e01a218e43274c49660ab882085f4b803bfd9f0ccde02b"

  url "https:github.comitouhiromixfont-mplus-ipareleasesdownloadv#{version}migu-1c-#{version.no_dots}.zip",
      verified: "github.comitouhiromixfont-mplus-ipa"
  name "Migu 1C"
  homepage "https:itouhiro.github.iomixfont-mplus-ipamigu"

  livecheck do
    url :homepage
    regex(%r{href=.*?downloadv?(\d+(?:\.\d+)+)migu-1c[._-]}i)
  end

  no_autobump! because: :requires_manual_review

  font "migu-1c-#{version.no_dots}migu-1c-bold.ttf"
  font "migu-1c-#{version.no_dots}migu-1c-regular.ttf"

  # No zap stanza required
end