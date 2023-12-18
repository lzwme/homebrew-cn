cask "radicle-upstream" do
  version "0.3.2"
  sha256 "d52d9c101c4c59fb414ef736c49e5f751ee1be5b407d3bf26e097bb01ffca29d"

  url "https:releases.radicle.xyzradicle-upstream-#{version}.dmg"
  name "Radicle Upstream"
  desc "Desktop client for Radicle, a p2p stack for code collaboration"
  homepage "https:radicle.xyz"

  livecheck do
    url "https:github.comradicle-devradicle-upstream"
  end

  depends_on macos: ">= :mojave"

  app "Radicle Upstream.app"

  zap trash: [
    "~.radicle",
    "~LibraryApplication SupportRadicle Upstream",
    "~LibraryApplication Supportxyz.radicle.radicle",
    "~LibraryApplication Supportxyz.radicle.radicle-upstream",
    "~LibraryPreferencesxyz.radicle.radicle-upstream.plist",
    "~LibrarySaved Application Statexyz.radicle.radicle-upstream.savedState",
  ]
end