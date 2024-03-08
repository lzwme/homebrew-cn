cask "kotlin-native" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.9.23"
  sha256 arm:   "27a3560dc9b79c58420ea0015c97838f44a49380854bf26397fb1cd52d6934ec",
         intel: "0eed7cce2e4323b6f9c58e9e76fcd4be2534e5d324355db8921f0ff9146cdc17"

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