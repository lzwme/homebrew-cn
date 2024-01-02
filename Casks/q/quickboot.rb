cask "quickboot" do
  version "1.1-92"
  sha256 "5119e1113949baae165efc726b757d58a887743f1dc6ae8d03a978be7b5da4a3"

  url "https:buttered-cat.comdownloadsget4QuickBoot-#{version}.zip"
  name "QuickBoot"
  homepage "https:buttered-cat.comproductquickboot"

  # no release in the past 10 years
  # user has reported it stopped working in catalina
  # https:github.comjfroQuickBootissues5
  deprecate! date: "2024-01-01", because: :unmaintained

  app "QuickBoot.app"
end