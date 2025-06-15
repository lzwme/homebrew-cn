cask "imagemin" do
  version "0.1.0"
  sha256 "8a4304d37eaa8a71fbeb550aece6a80c98dbcdf7a9fb6eb09faae1ad93df40d6"

  url "https:github.comimageminimagemin-appreleasesdownload#{version}imagemin-app-v#{version}-darwin.zip"
  name "imagemin"
  desc "Desktop image minifier"
  homepage "https:github.comimageminimagemin-app"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  # Renamed for clarity: app name is inconsistent with its branding.
  # Original discussion: https:github.comHomebrewhomebrew-caskpull4701
  app "imagemin-app-v#{version}-darwinAtom.app", target: "imagemin.app"
end