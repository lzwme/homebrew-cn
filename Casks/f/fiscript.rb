cask "fiscript" do
  version "1.0.1"
  sha256 "a622526479338a151c42f57b04717902555b33aad06abba249c8a4bb0554a0ed"

  url "https://ghfast.top/https://github.com/Mortennn/FiScript/releases/download/v#{version}/FiScript.zip"
  name "FiScript"
  homepage "https://github.com/Mortennn/FiScript"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-10", because: :unmaintained

  depends_on macos: ">= :sierra"

  app "FiScript.app"

  zap trash: [
    "~/Library/Application Scripts/com.Mortennn.FiScript",
    "~/Library/Application Scripts/com.Mortennn.FiScript.Finder-Extension",
    "~/Library/Containers/com.Mortennn.FiScript",
    "~/Library/Containers/com.Mortennn.FiScript.Finder-Extension",
    "~/Library/Group Containers/group.Mortennn.FiScript",
    "~/Library/Group Containers/group.Mortennn.FiScript",
    "~/Library/Group Containers/sharedContainerID.container",
  ]

  caveats do
    requires_rosetta
  end
end