cask "font-moralerspace-jpdoc" do
  version "1.1.0"
  sha256 "46581e9c3f2f41da4601649a9dacf54e0551b06a35ebea56b8760cb9358dde0f"

  url "https:github.comyuru7moralerspacereleasesdownloadv#{version}MoralerspaceJPDOC_v#{version}.zip"
  name "Moralerspace JPDOC"
  homepage "https:github.comyuru7moralerspace"

  no_autobump! because: :requires_manual_review

  font "MoralerspaceJPDOC_v#{version}MoralerspaceArgonJPDOC-Bold.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceArgonJPDOC-BoldItalic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceArgonJPDOC-Italic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceArgonJPDOC-Regular.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceKryptonJPDOC-Bold.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceKryptonJPDOC-BoldItalic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceKryptonJPDOC-Italic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceKryptonJPDOC-Regular.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceNeonJPDOC-Bold.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceNeonJPDOC-BoldItalic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceNeonJPDOC-Italic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceNeonJPDOC-Regular.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceRadonJPDOC-Bold.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceRadonJPDOC-BoldItalic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceRadonJPDOC-Italic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceRadonJPDOC-Regular.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceXenonJPDOC-Bold.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceXenonJPDOC-BoldItalic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceXenonJPDOC-Italic.ttf"
  font "MoralerspaceJPDOC_v#{version}MoralerspaceXenonJPDOC-Regular.ttf"

  # No zap stanza required
end