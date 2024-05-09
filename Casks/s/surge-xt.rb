cask "surge-xt" do
  version "1.3.2"
  sha256 "74748922bbcefb51b1ee55b6aebd5d2a8b54bdf88213e03eea2fad2cd81806ee"

  url "https:github.comsurge-synthesizerreleases-xtreleasesdownload#{version}surge-xt-macOS-#{version}.dmg",
      verified: "github.comsurge-synthesizerreleases-xt"
  name "Surge XT"
  desc "Hybrid synthesiser"
  homepage "https:surge-synthesizer.github.io"

  pkg "surge-xt-macOS-#{version}.pkg"

  uninstall pkgutil: [
              "com.surge-synth-team.surge-xt-fx.app.pkg",
              "com.surge-synth-team.surge-xt-fx.component.pkg",
              "com.surge-synth-team.surge-xt-fx.vst3.pkg",
              "com.surge-synth-team.surge-xt.app.pkg",
              "com.surge-synth-team.surge-xt.component.pkg",
              "com.surge-synth-team.surge-xt.resources.pkg",
              "com.surge-synth-team.surge-xt.vst3.pkg",
              "org.surge-synth-team.surge-xt-fx.app.pkg",
              "org.surge-synth-team.surge-xt-fx.clap.pkg",
              "org.surge-synth-team.surge-xt-fx.component.pkg",
              "org.surge-synth-team.surge-xt-fx.vst3.pkg",
              "org.surge-synth-team.surge-xt.app.pkg",
              "org.surge-synth-team.surge-xt.clap.pkg",
              "org.surge-synth-team.surge-xt.component.pkg",
              "org.surge-synth-team.surge-xt.resources.pkg",
              "org.surge-synth-team.surge-xt.vst3.pkg",
            ],
            delete:  [
              "ApplicationsSurge XT Effects.app",
              "ApplicationsSurge XT.app",
            ]

  # No zap stanza required
end