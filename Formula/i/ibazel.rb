class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "57997600ef4a6d54464d93a1ce8a35ad9b52e94bab823f97d4769d90c80022f4"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5133ada44cde1383f18a2b65c923935a0a5ae2bed500d714bcb87a1ae6ccb85d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89dc5599e59ac37b33de8e861be298ca29a16c1fdc441831cf21305f409f896c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41abae75b82bf37f4008b9abd27c0301f6f4dca8b54776499b3a0ab999f95c0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "de9000c010b86767c99a35e040d21fc5b3700ae69ceb3805c6d77478560a3f16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640c4ca04a95805c4076763d302225f931a39a516120d7f3831c9d7aef5fa319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e90f1e52b2bd0e953dcaa495dcf29620fd9d7006ee593fe0a644bdaf3a720efa"
  end

  depends_on "go" => [:build, :test]
  depends_on "bazel" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ibazel"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/ibazel --help 2>&1")

    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_go", version = "0.57.0")

      # Register brewed go
      go_sdk = use_extension("@rules_go//go:extensions.bzl", "go_sdk")
      go_sdk.host()
    STARLARK

    (testpath/"BUILD.bazel").write <<~STARLARK
      load("@rules_go//go:def.bzl", "go_binary")

      go_binary(
          name = "bazel-test",
          srcs = ["test.go"],
      )
    STARLARK

    (testpath/"test.go").write <<~GO
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    GO

    pid = spawn bin/"ibazel", "build", "//:bazel-test", "--repo_contents_cache="
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid) unless pid.nil?
  end
end