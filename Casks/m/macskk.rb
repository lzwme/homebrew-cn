cask "macskk" do
  version "1.13.0"
  sha256 "64e39f668da7c8ff8e871f77be287b541461cc383daa5d833bf33913761dbaf3"

  url "https:github.commtgtomacSKKreleasesdownload#{version}macSKK-#{version}.dmg"
  name "macSKK"
  desc "SKK Input Method"
  homepage "https:github.commtgtomacSKK"

  auto_updates true
  depends_on macos: ">= :ventura"

  pkg "macSKK-#{version}.pkg"

  uninstall quit:    [
              "net.mtgto.inputmethod.macSKK",
              "net.mtgto.inputmethod.macSKK.FetchUpdateService",
              "net.mtgto.inputmethod.macSKK.SKKServClient",
            ],
            pkgutil: [
              "net.mtgto.inputmethod.macSKK.app",
              "net.mtgto.inputmethod.macSKK.dict",
            ]

  zap trash: [
    "~LibraryApplication Scriptsnet.mtgto.inputmethod.macSKK",
    "~LibraryContainersnet.mtgto.inputmethod.macSKK",
  ]
end