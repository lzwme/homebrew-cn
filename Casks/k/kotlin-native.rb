cask "kotlin-native" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.1.20"
  sha256 arm:   "fc1503a8dcdadd9fb36f482a22716fce0d77a977fffb123e48a72c6826994ae0",
         intel: "53604b3a31668c45a92c6fb05f66f3a17f15139c57cca128d284b4b07e450d82"

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