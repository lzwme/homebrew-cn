cask "darktable" do
  arch arm: "arm64", intel: "x86_64"

  version "4.6.1"
  sha256 arm:   "145a11c3965b4c5cc2c53c9277f5896569fe55c05f2445f3185de94cd9667585",
         intel: "a7676fb36f208a41e026d806a0408d2364251d843810fd7dc2003e251ae09773"

  url "https:github.comdarktable-orgdarktablereleasesdownloadrelease-#{version.major_minor_patch}darktable-#{version}-#{arch}.dmg",
      verified: "github.comdarktable-orgdarktable"
  name "darktable"
  desc "Photography workflow application and raw developer"
  homepage "https:www.darktable.org"

  livecheck do
    url "https:www.darktable.orginstall"
    regex(href=.*?darktable[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  app "darktable.app"

  zap trash: [
    "~.cachedarktable",
    "~.configdarktable",
    "~.localsharedarktable",
    "~LibrarySaved Application Stateorg.darktable.savedState",
  ]
end