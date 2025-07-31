class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.26.8.tar.gz"
  sha256 "bdbfb0c2481d8915275980b4ba785890241c0e8100e6c81a62b13d966867a696"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4380a40d82e85bc3893cb249cfcf832a14c00307415a57599ba7b5dbff4a6611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3056ac82ef4a2cdb14251809b62335e7da97f08990308bdb7a517620226bbd49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66d4f6ea1b4f475cde023d3c2754b7171f60bdc000de2d49ab291c937557eeda"
    sha256 cellar: :any_skip_relocation, sonoma:        "6638e8a22e6e41f4c5ab1e66ab23305d7e44410bf88153bc9b50defca4150c81"
    sha256 cellar: :any_skip_relocation, ventura:       "859e45bdf5b4786226d8ed143067151e33e3bbb63332d098a55d9552530e4495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9c8ccfb43bf0b15cb4a6f2360aca6debec1b90f0d8490f42f5b779450a16857"
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