class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "e9e4ba8c2f097314e6c086e9e6482770d54db86f39488fa037af194a84c00591"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c81d7b6ccd3ddecd8d973c1ec3d94f18fb0ff02de346a0c03495833bf323d4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c06b233961ff8931f0050765d92f3458a62ba7bfb99065238aa3054b55e9966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa3a373711638fbc2ea0428c8904562d059683d77851eab2579b1b720e23345c"
    sha256 cellar: :any_skip_relocation, sonoma:        "11fc796158a79563f8fa8e64631b613fca2faf6c25408efd4664376030d629b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d9e3c94ccb249c6ae90a818c8e5b38cc8b0eeff00eca655a55f99660062ce9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02dcc1df219ca9bff5e86a55256fa5efb119a5422aec8b6fcdf433934a8ba770"
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