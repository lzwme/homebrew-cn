class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/SourceDocs/SourceDocs"
  url "https://ghfast.top/https://github.com/SourceDocs/SourceDocs/archive/refs/tags/2.0.1.tar.gz"
  sha256 "07547c929071124264ec9cc601331f21dc67a104ffc76fbc1801c1ecb4c35bbf"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4914567b0171f3dfcab46315e33232e5c925077268af59ce0ff5955c948dcb6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5461899a0c97729c247703f45eb98a0cf26fc9939ce50eb6fa9543e9f70c6c62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbe4a3e5c3485101486be0639b81cc4799c2dd7e0edf5f528d32a3c0ca6122fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8757a91d73d96999da362afbc5a5c42c7be949f562cf5569b2bf24853af6ef9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1254fb0f47a037f929e579b4a68dd375b0e587d9adb3e876865b6de031d39f46"
    sha256 cellar: :any_skip_relocation, sonoma:         "9378990038e4d444ca11820d4e41eee737522dc75b7818d7577f4a612ab18bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "5cf36d5bfe2a9a2770454f21169e5e9c8a5a6b50525ec0a9418c88180706d40c"
    sha256 cellar: :any_skip_relocation, monterey:       "974904c0b5b4d0d54fe8392c84fe06b3aa23e47fb76f95579f09e5fc94704d2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "292dbf6713d17716e685ac74c0e9fdbe07038b95bca36f234a94bfe2fffe5aab"
    sha256 cellar: :any_skip_relocation, catalina:       "56cad5d1e01271614fd93c5ec93b4b7fc7cabb64bef767581bc5ad179ee20a63"
    sha256                               arm64_linux:    "a5ede432a4cc147f30658c33f26b704e039b102f0c10d6e522296818dbb2bfdd"
    sha256                               x86_64_linux:   "ebd23518f4371e70e885900d73fdf0ea71a4d30a0695a1dff8fa4d762abfa5e1"
  end

  depends_on xcode: ["12.0", :build, :test]
  uses_from_macos "swift"

  # Workaround until SourceKitten dependency is updated
  # Ref: https://github.com/SourceDocs/SourceDocs/pull/83
  resource "SourceKitten" do
    if DevelopmentTools.clang_build_version >= 1600
      # https://github.com/SourceDocs/SourceDocs/blob/2.0.1/Package.resolved#L32-L38
      url "https://github.com/jpsim/SourceKitten.git",
          tag:      "0.32.0",
          revision: "817dfa6f2e09b0476f3a6c9dbc035991f02f0241"

      # Backport of import from HEAD
      patch :DATA
    end
  end

  def install
    args = ["--disable-sandbox", "--configuration", "release"]
    if DevelopmentTools.clang_build_version >= 1600
      res = resource("SourceKitten")
      (buildpath/"SourceKitten").install res

      pin_version = JSON.parse(File.read("Package.resolved"))
                        .dig("object", "pins")
                        .find { |pin| pin["package"] == "SourceKitten" }
                        .dig("state", "version")
      odie "Check if SourceKitten patch is still needed!" if pin_version != res.version

      system "swift", "package", *args, "edit", "SourceKitten", "--path", buildpath/"SourceKitten"
    end

    system "swift", "build", *args
    bin.install ".build/release/sourcedocs"
  end

  test do
    assert_match "SourceDocs v#{version}", shell_output("#{bin}/sourcedocs version")

    # There are some issues with SourceKitten running in sandbox mode in Mojave
    # The following test has been disabled on Mojave until that issue is resolved
    # - https://github.com/Homebrew/homebrew/pull/50211
    # - https://github.com/Homebrew/homebrew-core/pull/32548
    if OS.mac? && MacOS.version < "10.14"
      mkdir "foo" do
        system "swift", "package", "init"
        system "swift", "build", "--disable-sandbox"
        system bin/"sourcedocs", "generate",
               "--spm-module", "foo",
               "--output-folder", testpath/"Documentation/Reference"
        assert_path_exists testpath/"Documentation/Reference/README.md"
      end
    end
  end
end

__END__
diff --git a/Source/SourceKittenFramework/SwiftDocs.swift b/Source/SourceKittenFramework/SwiftDocs.swift
index 1d2473c..70de287 100644
--- a/Source/SourceKittenFramework/SwiftDocs.swift
+++ b/Source/SourceKittenFramework/SwiftDocs.swift
@@ -10,6 +10,14 @@
 import SourceKit
 #endif

+#if os(Linux)
+import Glibc
+#elseif os(Windows)
+import CRT
+#else
+import Darwin
+#endif
+
 /// Represents docs for a Swift file.
 public struct SwiftDocs {
     /// Documented File.