cask "gulp" do
  version "0.1.0"
  sha256 "59fed5d8c801c9302debf463f2d274404548e23433c965144e69a0b4a2e23851"

  url "https://ghfast.top/https://github.com/sindresorhus/gulp-app/releases/download/#{version}/gulp.app.zip"
  name "gulp-app"
  homepage "https://github.com/sindresorhus/gulp-app"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-07-11", because: "is 32-bit only"

  app "gulp.app"

  # No zap stanza required
end