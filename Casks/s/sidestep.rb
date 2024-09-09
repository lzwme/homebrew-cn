cask "sidestep" do
  version "1.4.1"
  sha256 "c25f7748d73b6f915aff268070ef85ca69f2902de98b044b77c49d1e1341d84e"

  url "https:github.comchetan51sidestepreleasesdownload#{version}Sidestep.zip",
      verified: "github.comchetan51sidestep"
  name "Sidestep"
  homepage "https:chetansurpur.comprojectssidestep"

  deprecate! date: "2024-09-08", because: :unmaintained

  app "Sidestep.app"

  caveats do
    requires_rosetta
  end
end