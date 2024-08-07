cask "kotlin-native" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.0.10"
  sha256 arm:   "01d26be087a39e5e01be5a27677bb16d34a69b38c136506c38a49a696dae3de8",
         intel: "b246f529c74ef190b9cd215a5f662a81b52dc3bee2b48f7805ebf2e83d0c3645"

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