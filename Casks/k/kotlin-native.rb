cask "kotlin-native" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.2.0"
  sha256 arm:   "53e68794a19e7399bf8fec905c96f486595aefe90d2e9c65421c72dc059bcbfd",
         intel: "43e7135762756e9fd6f2f5afcc259d87ebf85e500e16f82910c49ea39e8b2577"

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