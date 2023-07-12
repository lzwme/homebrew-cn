class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghproxy.com/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "5d449dc6bc9507c29d6b774b763d1ce8eee23d74f241f975770631f493dc11d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b73204bab84950acbbdf5cb9dd448b12a3f49bb3483780f00f6976ac599bec01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78e93f5537a58c939684868d76577400f86a9aa2a5014fedb6806a6d627fd5bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "235e81b67ca0c074e5462a9ff1533d8af27ed0edfeccd407bd5ff83993cbc84e"
    sha256 cellar: :any_skip_relocation, ventura:        "42d5389d3e8af2214b0ee3234c9de6ef1527693864487781ad69871c4a269543"
    sha256 cellar: :any_skip_relocation, monterey:       "1aa69933ea008e7d0cf66b40017513acf66b77d821bc594acddac6d80cef4efa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee5483e401a5c0cd813865dbae18552202940d88c089c735e3524324580a6507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a42f541ff46aa784a8f85fafa7d054108d09f242034e1b894febd5a360171e51"
  end

  depends_on "go" => [:build, :test]

  on_macos do
    depends_on "bazel" => [:build, :test]
  end

  on_linux do
    depends_on "bazelisk" => [:build, :test]
  end

  # bazel 6.x support issue, https://github.com/bazelbuild/bazel-watcher/issues/616
  # patch to use bazel 6.2.1, upstream PR, https://github.com/bazelbuild/bazel-watcher/pull/575
  patch :DATA

  def install
    system "bazel", "build", "--config=release", "--workspace_status_command", "echo STABLE_GIT_VERSION #{version}", "//cmd/ibazel:ibazel"
    bin.install "bazel-bin/cmd/ibazel/ibazel_/ibazel"
  end

  test do
    # Test building a sample Go program
    (testpath/"WORKSPACE").write <<~EOS
      load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

      http_archive(
        name = "io_bazel_rules_go",
        sha256 = "dd926a88a564a9246713a9c00b35315f54cbd46b31a26d5d8fb264c07045f05d",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.38.1/rules_go-v0.38.1.zip",
            "https://ghproxy.com/https://github.com/bazelbuild/rules_go/releases/download/v0.38.1/rules_go-v0.38.1.zip",
        ],
      )

      load("@io_bazel_rules_go//go:deps.bzl", "go_host_sdk", "go_rules_dependencies")

      go_rules_dependencies()

      go_host_sdk(name = "go_sdk")
    EOS

    (testpath/"test.go").write <<~EOS
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    EOS

    (testpath/"BUILD").write <<~EOS
      load("@io_bazel_rules_go//go:def.bzl", "go_binary")

      go_binary(
        name = "bazel-test",
        srcs = glob(["*.go"])
      )
    EOS

    pid = fork { exec("ibazel", "build", "//:bazel-test") }
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid)
    sleep 1
    Process.kill("TERM", pid)
  end
end

__END__
diff --git a/.bazelversion b/.bazelversion
index 8a30e8f..09b254e 100644
--- a/.bazelversion
+++ b/.bazelversion
@@ -1 +1 @@
-5.4.0
+6.2.1