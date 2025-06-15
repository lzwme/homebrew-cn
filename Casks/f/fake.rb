cask "fake" do
  version "1.9.1"
  sha256 "eb4f02a3b5dea2cab679c1366f454a22d8bb4bbfa448c56c0ca00bb615d8867e"

  url "https://fakeapp.com/dist/Fake_#{version}.zip"
  name "Fake"
  desc "Browser for web automation and testing"
  homepage "https://fakeapp.com/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-10", because: :unmaintained

  app "Fake.app"

  caveats do
    requires_rosetta
  end
end