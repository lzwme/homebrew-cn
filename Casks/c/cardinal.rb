cask "cardinal" do
  version "24.12"
  sha256 "ee4cb6c3d94056e72c8249a9bd061722704689eb98f8db3e1d910ad51ec87255"

  url "https:github.comDISTRHOCardinalreleasesdownload#{version}Cardinal-macOS-universal-#{version}.pkg"
  name "Cardinal"
  desc "Virtual modular synthesiser plugin"
  homepage "https:github.comDISTRHOCardinal"

  no_autobump! because: :requires_manual_review

  pkg "Cardinal-macOS-universal-#{version}.pkg"

  uninstall pkgutil: [
    "studio.kx.distrho.cardinal.resources",
    "studio.kx.distrho.plugins.cardinal.clapbundles",
    "studio.kx.distrho.plugins.cardinal.components",
    "studio.kx.distrho.plugins.cardinal.jack",
    "studio.kx.distrho.plugins.cardinal.lv2bundles",
    "studio.kx.distrho.plugins.cardinal.native",
    "studio.kx.distrho.plugins.cardinal.vst2bundles",
    "studio.kx.distrho.plugins.cardinal.vst3bundles",
  ]

  # No zap stanza required
end