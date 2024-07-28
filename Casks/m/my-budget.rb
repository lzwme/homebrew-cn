cask "my-budget" do
  version "3.4.2-beta"
  sha256 "ba47e4e4feb184a540f944cb69fbbc8f6a6d7a71ec5312e8f7d58fd20d125a34"

  url "https:github.comreZachmy-budgetreleasesdownload#{version}my-budget-#{version}.dmg",
      verified: "github.comreZachmy-budget"
  name "My Budget"
  desc "Budgeting tool"
  homepage "https:rezach.github.iomy-budget"

  deprecate! date: "2024-07-27", because: :unmaintained

  app "My Budget.app"

  caveats do
    requires_rosetta
  end
end