class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "bebb299fc32660934dc5db9e7794b58b94e638e486dad4b5b03786875c4ff2f9"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc9440a5287ce8387a1bd269b6f9f3c04a7f851d659940a4ac27659ec2306390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "187bb9ccb044259c6484462a98937a1ca5380a0ef01f9154e4fb1f8bb2a17171"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54a02e3318ecba126b76a18bcf9e1eb7ff239b0ef21882c8e8f2803a331e3c3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea941e71159ab07c3244425eac579de8dc51c100e0be368fc40c2d54b8312f1"
    sha256 cellar: :any_skip_relocation, ventura:       "e9792504613ded6cabd8fa0100cfc2d2e79349d6b88a3be6bd7d40f828628e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3a2a7e8303962e0572af577857273881d1f4516fb132c6d47238425a079adc"
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