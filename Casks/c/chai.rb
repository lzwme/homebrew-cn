cask "chai" do
  version "3.3.0"
  sha256 "f8b32b671363634fdb9227c40d4d69c90bb3779b73ea28b6831ea7d4d0c5908f"

  url "https:github.comlvillanichaireleasesdownloadv#{version}Chai-v#{version}.zip"
  name "Chai"
  desc "Utility to prevent the system from going to sleep"
  homepage "https:github.comlvillanichai"

  depends_on macos: ">= :mojave"

  app "Chai.app"

  zap trash: [
    "~LibraryApplication Scriptsme.villani.lorenzo.Chai",
    "~LibraryContainersme.villani.lorenzo.Chai",
  ]
end