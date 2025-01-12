cask "nocturn" do
  version "1.8.4"
  sha256 "c51eac959ccbd4eaf657ff93735de2dbc138faa26d2d56a7f89aeeea30751e9b"

  url "https:github.comk0kubunNocturnreleasesdownloadv#{version}Nocturn-darwin-x64.zip"
  name "Nocturn"
  desc "Multi-platform Twitter client"
  homepage "https:github.comk0kubunNocturn"

  deprecate! date: "2024-01-11", because: :discontinued
  disable! date: "2025-01-11", because: :discontinued

  app "Nocturn-darwin-x64Nocturn.app"

  caveats do
    requires_rosetta
  end
end