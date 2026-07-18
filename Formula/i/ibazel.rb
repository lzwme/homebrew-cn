class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "c23811859ba27ff7a938f026fb6a46b5b972039702108f3b87d074f92959dbd0"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ffe965a53ee8a123243a3458d48e6039cc611080929e0d23e534d8875c43a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0178f7e0c8aed764a418db14d999f3f5a927867a13ce09622f663dd5c8f1f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35cef9ce51b710fc71bc16ca309b8b6a7a9f31c89b1275a178b135b269217b5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4626494294fefe52d54777573c040e97f6ac0ad1e3a725cd252ebea746cffeca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9beb0f135d601b9f2cb53d787639e0387d1c93e96cff89d971b7130fd00996b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d26c9c6c47c561d04ee0e024e12ffa34230bc7697ea603a8085add118c1ade"
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
      bazel_dep(name = "rules_cc", version = "0.2.16")
      bazel_dep(name = "rules_go", version = "0.59.0")

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