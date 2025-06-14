cask "asset-catalog-tinkerer" do
  version "2.9"
  sha256 "ab18ece5d597960f9002c84cc800b61b2b22f4f61a63d6695dac378340ded5c0"

  url "https:github.cominsideguiAssetCatalogTinkererreleasesdownload#{version}AssetCatalogTinkerer_v#{version}-#{version.no_dots.ljust(3, "0")}.zip"
  name "Asset Catalog Tinkerer"
  desc "Browseextract images from .car files"
  homepage "https:github.cominsideguiAssetCatalogTinkerer"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "Asset Catalog Tinkerer.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsbr.com.guilhermerambo.asset-catalog-tinkerer.sfl*",
    "~LibraryPreferencesbr.com.guilhermerambo.Asset-Catalog-Tinkerer.plist",
  ]
end