class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghproxy.com/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "d0f01547b9b3f22b779db15528c58e81436551b380848cd2b80fa426d7ca75c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "099eed1e74bfd6315759bf056dd3b45e9add4c06a5beda8a794eb2c3b0d9fb8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c064002a23e450b7283ff82b863424c533a83e85c1ffb717b41d0c74f785c4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b26248fa70f9b0e134c55d35e2cc00009826cd3ff34f43c07628a7d5c89a999"
    sha256 cellar: :any_skip_relocation, ventura:        "41a2f3ffc4c0590517b2568dc34dfe70519caf08b8acc2c5646872ebf03c3006"
    sha256 cellar: :any_skip_relocation, monterey:       "8574601df01ce80f979fbfa323c2a8f8f347a0562ea2fda64fbf8e6218086ef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "880f8cb99693ab94a76f4525e8f5afc4394c54a2237a7226eb38a5d2bcf956bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5180274d2b4c2c6e09c981628ad2955abfa86ef606e3bcaa33332677319d40d6"
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