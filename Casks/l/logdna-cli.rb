cask "logdna-cli" do
  version "2.0.0"
  sha256 "5a9e2b3928f8d1cb294be4b5be3e96a44cc3076e0bb70133a6ccbb1c09ec681a"

  url "https:github.comlogdnalogdna-clireleasesdownload#{version}logdna-cli.pkg",
      verified: "github.comlogdnalogdna-cli"
  name "LogDNA CLI"
  desc "Command-line interface for LogDNA"
  homepage "https:www.mezmo.com"

  pkg "logdna-cli.pkg"

  uninstall pkgutil: "com.logdna.logdna-cli"

  # No zap stanza required
end