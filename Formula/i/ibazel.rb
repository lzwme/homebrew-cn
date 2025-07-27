class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/V0.26.6.tar.gz"
  sha256 "2183c386d7576ff9cf30e762bb202d14ea5d7f63bc7861a90e999e02ab3a19aa"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bb04ac62d6273c93aeef58aef9e1fc1ce58c354fd84e3a5982d215b97e2a169"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcfcaaf9524723c3873c533105ed5c4a7e87c2b7265d7f5eee0fc0a3269b7790"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "741f21a4dd02aa73065f01b8d6c7b9415615aa57e3976a56efdf280163f6b22d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e363da17828db7234a01550283d544d9ecc4cfd970c58829f8995b8b872c9c3"
    sha256 cellar: :any_skip_relocation, ventura:       "670485681c2f15cd74ea520bfa50e4305442f8650a1ce9ce85163db556a1bb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23bd7d5d8f727dffbdb5d13ac16f92d7668c5b51b13e9e095d939642844a00c0"
  end

  depends_on "go" => [:build, :test]
  depends_on "bazel" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ibazel"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/ibazel --help 2>&1")

    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_go", version = "0.55.1")

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