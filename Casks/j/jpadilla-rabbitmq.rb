cask "jpadilla-rabbitmq" do
  version "3.6.1-build.1"
  sha256 "1838afcece704ab1d23645d5d44953b809474f1f67ec4b18f3f98d440e5b5aad"

  url "https:github.comjpadillarabbitmqappreleasesdownload#{version}RabbitMQ.zip",
      verified: "github.comjpadillarabbitmqapp"
  name "RabbitMQ"
  desc "App wrapper for RabbitMQ"
  homepage "https:jpadilla.github.iorabbitmqapp"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-04-15", because: :unmaintained

  app "RabbitMQ.app"

  zap trash: [
    "~LibraryCachesio.blimp.RabbitMQ",
    "~LibraryPreferencesio.blimp.RabbitMQ.plist",
  ]

  caveats do
    requires_rosetta
  end
end