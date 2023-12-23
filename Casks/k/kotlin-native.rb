cask "kotlin-native" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.9.22"
  sha256 arm:   "8a95c0e0eb46b41b6d02a1942dc7dfe8c70082a2a26679490a77cd486f0ec8dd",
         intel: "a9d7bcf38a41a84002ba7a733b08e97b554225a39656d5158fc31dc6d0acede4"

  url "https:github.comJetBrainskotlinreleasesdownloadv#{version}kotlin-native-macos-#{arch}-#{version}.tar.gz",
      verified: "github.comJetBrainskotlin"
  name "Kotlin Native"
  desc "LLVM backend for Kotlin"
  homepage "https:kotlinlang.orgdocsreferencenative-overview.html"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  conflicts_with formula: "kotlin"

  binary "kotlin-native-macos-#{arch}-#{version}bincinterop"
  binary "kotlin-native-macos-#{arch}-#{version}bingenerate-platform"
  binary "kotlin-native-macos-#{arch}-#{version}binjsinterop"
  binary "kotlin-native-macos-#{arch}-#{version}binklib"
  binary "kotlin-native-macos-#{arch}-#{version}binkonan-lldb"
  binary "kotlin-native-macos-#{arch}-#{version}binkonanc"
  binary "kotlin-native-macos-#{arch}-#{version}binkotlinc-native"
  binary "kotlin-native-macos-#{arch}-#{version}binrun_konan"

  # No zap stanza required
  caveats do
    depends_on_java "6+"
  end
end