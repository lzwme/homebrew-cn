cask "imagemin" do
  version "0.1.0"
  sha256 "8a4304d37eaa8a71fbeb550aece6a80c98dbcdf7a9fb6eb09faae1ad93df40d6"

  url "https://ghfast.top/https://github.com/imagemin/imagemin-app/releases/download/#{version}/imagemin-app-v#{version}-darwin.zip"
  name "imagemin"
  desc "Desktop image minifier"
  homepage "https://github.com/imagemin/imagemin-app"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  # Renamed for clarity: app name is inconsistent with its branding.
  # Original discussion: https://github.com/Homebrew/homebrew-cask/pull/4701
  app "imagemin-app-v#{version}-darwin/Atom.app", target: "imagemin.app"
end