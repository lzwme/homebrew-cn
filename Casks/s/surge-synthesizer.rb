cask "surge-synthesizer" do
  version "1.9.0"
  sha256 "f64329c0dcba60fea9c7bf56c584e124de24527e6625dab19f1f689b128880e5"

  url "https:github.comsurge-synthesizerreleasesreleasesdownload#{version}Surge-#{version}-Setup.dmg",
      verified: "github.comsurge-synthesizerreleases"
  name "Surge"
  desc "Hybrid synthesizer"
  homepage "https:surge-synthesizer.github.io"

  pkg "Surge-#{version}-Setup.pkg"

  uninstall pkgutil: [
    "com.vemberaudio.vst2.pkg",
    "com.vemberaudio.vst3.pkg",
    "com.vemberaudio.au.pkg",
    "com.vemberaudio.resources.pkg",
    "org.surge-synthesizer.fxau.pkg",
    "org.surge-synthesizer.fxvst3.pkg",
  ]
end