cask "next" do
  version "2.052"
  sha256 :no_check

  url "https://next.atlas.engineer/static/release/next-macos-webkit.dmg"
  name "Next Browser"
  desc "Web browser"
  homepage "https://next.atlas.engineer/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Next.app"

  zap trash: "~/Library/Caches/next.browser"
end