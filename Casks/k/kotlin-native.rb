cask "kotlin-native" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.1.21"
  sha256 arm:   "8df16175b962bc4264a5c3b32cb042d91458babbd093c0f36194dc4645f5fe2e",
         intel: "fc6b5979ec322be803bfac549661aaf0f8f7342aa3bd09008d471fff2757bbdf"

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