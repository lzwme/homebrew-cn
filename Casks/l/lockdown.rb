cask "lockdown" do
  version "1.0.0"
  sha256 "047f377e2a9495361084268c86cc80719e123bd8958d69fe51cd2be0d7ffd764"

  url "https://bitbucket.org/objective-see/deploy/downloads/Lockdown_#{version}.zip",
      verified: "bitbucket.org/objective-see/"
  name "Lockdown"
  desc "Audits and remediates security configuration settings"
  homepage "https://objective-see.org/products/lockdown.html"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-03-02", because: :unmaintained

  app "Lockdown.app"

  caveats do
    requires_rosetta
  end
end