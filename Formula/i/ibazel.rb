class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.26.7.tar.gz"
  sha256 "6d0fed6626ebae078eddfe2f2174eb2d0358d03cc943c3b8f6792e68dfc121c0"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd659b68e396d690701a7236ab80722837c297d86520009ae92baaaad9f5c59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f230900503dc84cc0524cbb650f467084f33f8393c279a80352de8fbd36e8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5ffc6d9abf79713edeed24b73a0ad1cd395cafd930db17cfbc79786c2e95176"
    sha256 cellar: :any_skip_relocation, sonoma:        "9111bbe3d3b9f9e2521090388d5e058c7e401747961f78d301fb3d265da843d0"
    sha256 cellar: :any_skip_relocation, ventura:       "06f731b5a938688069911aa334a48a683bc925d9decf9dae939e6728c30b2146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b73d975fecde2f8110fc86def4da524bd2b0ce8226e6386010f7db9b65d7b55"
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