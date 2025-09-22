cask "gltfquicklook" do
  version "0.3.0"
  sha256 "f460f3ab10766e51d03ac3eaa718752a42ffce7e92df5f440abf426e2ce44a39"

  url "https://ghfast.top/https://github.com/magicien/GLTFQuickLook/releases/download/v#{version}/GLTFQuickLook_v#{version}.zip"
  name "GLTFQuickLook"
  desc "Quick Look plugin for glTF files"
  homepage "https://github.com/magicien/GLTFQuickLook"

  deprecate! date: "2025-09-22", because: :no_longer_meets_criteria

  qlplugin "GLTFQuickLook.qlgenerator"

  # No zap stanza required
end