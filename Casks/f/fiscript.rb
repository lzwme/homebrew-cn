cask "fiscript" do
  version "1.0.1"
  sha256 "a622526479338a151c42f57b04717902555b33aad06abba249c8a4bb0554a0ed"

  url "https:github.comMortennnFiScriptreleasesdownloadv#{version}FiScript.zip"
  name "FiScript"
  homepage "https:github.comMortennnFiScript"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-10", because: :unmaintained

  depends_on macos: ">= :sierra"

  app "FiScript.app"

  zap trash: [
    "~LibraryApplication Scriptscom.Mortennn.FiScript",
    "~LibraryApplication Scriptscom.Mortennn.FiScript.Finder-Extension",
    "~LibraryContainerscom.Mortennn.FiScript",
    "~LibraryContainerscom.Mortennn.FiScript.Finder-Extension",
    "~LibraryGroup Containersgroup.Mortennn.FiScript",
    "~LibraryGroup Containersgroup.Mortennn.FiScript",
    "~LibraryGroup ContainerssharedContainerID.container",
  ]

  caveats do
    requires_rosetta
  end
end