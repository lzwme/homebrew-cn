cask "aware" do
  version "1.2.0"
  sha256 "f39d1fabc3a80df649bbb7aa6c596d0fc5082d8718d442ba857ec49bf7fe5eab"

  url "https:github.comjoshAwarereleasesdownloadv#{version}Aware.app.zip",
      verified: "github.comjoshAware"
  name "Aware"
  desc "Menubar app to track active computer use"
  homepage "https:awaremac.com"

  deprecate! date: "2024-10-04", because: :unmaintained

  depends_on macos: ">= :sonoma"

  app "Aware.app"

  zap trash: [
    "~LibraryApplication Scriptscom.awaremac.Aware",
    "~LibraryContainerscom.awaremac.Aware",
  ]
end