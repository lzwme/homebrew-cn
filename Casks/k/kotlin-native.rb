cask "kotlin-native" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.1.10"
  sha256 arm:   "b0ae655517c63add979462ac6668f3b1c00159d3fbf312dcb2e5752755facb3c",
         intel: "d7aebac0b5c4bf5adf7b76eac0b9c0cf79bee2e350c03ca93ef24c3cfadbe5cb"

  url "https:github.comJetBrainskotlinreleasesdownloadv#{version}kotlin-native-prebuilt-macos-#{arch}-#{version}.tar.gz",
      verified: "github.comJetBrainskotlin"
  name "Kotlin Native"
  desc "LLVM backend for Kotlin"
  homepage "https:kotlinlang.orgdocsreferencenative-overview.html"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  conflicts_with formula: "kotlin"

  binary "kotlin-native-prebuilt-macos-#{arch}-#{version}bincinterop"
  binary "kotlin-native-prebuilt-macos-#{arch}-#{version}bingenerate-platform"
  binary "kotlin-native-prebuilt-macos-#{arch}-#{version}binjsinterop"
  binary "kotlin-native-prebuilt-macos-#{arch}-#{version}binklib"
  binary "kotlin-native-prebuilt-macos-#{arch}-#{version}binkonan-lldb"
  binary "kotlin-native-prebuilt-macos-#{arch}-#{version}binkonanc"
  binary "kotlin-native-prebuilt-macos-#{arch}-#{version}binkotlinc-native"
  binary "kotlin-native-prebuilt-macos-#{arch}-#{version}binrun_konan"

  # No zap stanza required
  caveats do
    depends_on_java "6+"
  end
end