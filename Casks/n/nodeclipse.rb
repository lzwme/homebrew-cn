cask "nodeclipse" do
  version "2015.7,20150706"
  sha256 "674991d7c22ea05975a76800e6e9fe9231064a09a2a2412e6ec0448676bfa2e8"

  url "https://downloads.sourceforge.net/nodeclipse/Enide-#{version.major}/#{version.minor}/Enide-#{version.major}-#{version.minor}-macosx-x64-#{version.csv.second}.zip",
      verified: "sourceforge.net/nodeclipse/"
  name "Nodeclipse"
  desc "Node.js tooling with Eclipse"
  homepage "https://nodeclipse.github.io/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-09-01", because: :unmaintained

  # Renamed for clarity: app name is inconsistent with its branding.
  # Also renamed to avoid conflict with other eclipse Casks.
  # Original discussion: https://github.com/Homebrew/homebrew-cask/pull/8183
  app "Eclipse.app", target: "Nodeclipse.app"

  caveats do
    requires_rosetta
  end
end