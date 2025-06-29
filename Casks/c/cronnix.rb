cask "cronnix" do
  version "3.0.2"
  sha256 "e61144dc7b489d581fea10bc5d04dab1c0ea590ba8a69ed5d3c4e4617f557cd2"

  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cronnix/CronniX_#{version}.app.zip",
      verified: "googleapis.com/google-code-archive-downloads/v2/code.google.com/cronnix/"
  name "CronniX"
  homepage "https://code.google.com/archive/p/cronnix/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-07-09", because: "is 32-bit only"

  app "CronniX.app"
end