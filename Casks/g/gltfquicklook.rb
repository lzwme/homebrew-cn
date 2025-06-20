cask "gltfquicklook" do
  version "0.3.0"
  sha256 "f460f3ab10766e51d03ac3eaa718752a42ffce7e92df5f440abf426e2ce44a39"

  url "https:github.commagicienGLTFQuickLookreleasesdownloadv#{version}GLTFQuickLook_v#{version}.zip"
  name "GLTFQuickLook"
  desc "Quick Look plugin for glTF files"
  homepage "https:github.commagicienGLTFQuickLook"

  no_autobump! because: :requires_manual_review

  qlplugin "GLTFQuickLook.qlgenerator"

  # No zap stanza required
end