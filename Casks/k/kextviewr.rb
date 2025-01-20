cask "kextviewr" do
  version "2.0.0"
  sha256 "cd92141750812797cffd626f697c133fac84b615b5d4cd5dae56a8160320968e"

  url "https:github.comobjective-seeKextViewrreleasesdownloadv#{version}KextViewr_#{version}.zip",
      verified: "github.comobjective-see"
  name "KextViewr"
  desc "Display all currently loaded kexts"
  homepage "https:objective-see.orgproductskextviewr.html"

  depends_on macos: ">= :big_sur"

  app "KextViewr.app"

  zap trash: "~LibraryCachescom.objective-see.KextViewr"
end