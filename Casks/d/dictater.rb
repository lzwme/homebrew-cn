cask "dictater" do
  version "1.2"
  sha256 "32ae561c93af4979d23c0c8e22f31665a93f4f654539a0c10f725b35a62c9557"

  url "https:github.comNosracDictaterreleasesdownload#{version}Dictater.zip",
      verified: "github.comNosracDictater"
  name "Dictater"
  homepage "https:nosrac.github.ioDictater"

  deprecate! date: "2024-07-10", because: :unmaintained

  app "Dictater.app"

  caveats do
    requires_rosetta
  end
end