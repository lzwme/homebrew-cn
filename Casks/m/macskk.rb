cask "macskk" do
  version "1.13.3"
  sha256 "c9f2e08e91b790fcdeccb4af323bd9d686f8f58928975f1a2d2b48c61625af00"

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