cask "kotlin-native" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.9.24"
  sha256 arm:   "4465e2d92c94be21fd1dd300a52a0125f11d78e7e7b2c6939d695dbc627acac6",
         intel: "783c1b9955748cb3794446f70f925f0db8f352e66e8f1036a6ec3be537b5685b"

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