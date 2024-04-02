class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https:github.combazelbuildbazel-watcher"
  # Tag may change on next release: https:github.combazelbuildbazel-watcherissues652
  url "https:github.combazelbuildbazel-watcherarchiverefstagsV0.25.1.tar.gz"
  sha256 "8faa43a7d79e5991ca79cead0c91187c5b1c61aed0f86d726401bff91abf9d20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1030050c20f2824c410de9d0e01ff4a36b96a15787cc93726c064d7ee462dfaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47279d9d1a55e2ea050bfa1ad65cdc353be0a7eee129ee8118a2bbb25db00232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aff4781602399966187dc11e1faf0972c1fe5f2b503681ee85e1fadd16f645f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c99c7e54aa6925ff14bf44a1a99ce4c60587547170494a332b7734d172c7759"
    sha256 cellar: :any_skip_relocation, ventura:        "b29223b3772b99d5e693e95951bcf9a940a157d01c54156f889a6085bcff146d"
    sha256 cellar: :any_skip_relocation, monterey:       "9a1f28da8705ee68bcec9d9a7386a51518d61195db1e2b303768689e53a36738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aeb030a3da8a41e9ea99dc7b6d8a73d81fa453b9425c95366538071525d80be"
  end

  depends_on "bazelisk" => [:build, :test]
  depends_on "go" => [:build, :test]

  # bazel 6.x support issue, https:github.combazelbuildbazel-watcherissues616
  # patch to use bazel 6.4.0, upstream PR, https:github.combazelbuildbazel-watcherpull575
  patch :DATA

  def install
    system "bazel", "build", "--config=release", "--workspace_status_command", "echo STABLE_GIT_VERSION #{version}", "cmdibazel:ibazel"
    bin.install "bazel-bincmdibazelibazel_ibazel"
  end

  test do
    # Test building a sample Go program
    (testpath"WORKSPACE").write <<~EOS
      load("@bazel_toolstoolsbuild_defsrepo:http.bzl", "http_archive")

      http_archive(
        name = "io_bazel_rules_go",
        sha256 = "278b7ff5a826f3dc10f04feaf0b70d48b68748ccd512d7f98bf442077f043fe3",
        urls = [
            "https:mirror.bazel.buildgithub.combazelbuildrules_goreleasesdownloadv0.41.0rules_go-v0.41.0.zip",
            "https:github.combazelbuildrules_goreleasesdownloadv0.41.0rules_go-v0.41.0.zip",
        ],
      )

      load("@io_bazel_rules_gogo:deps.bzl", "go_host_sdk", "go_rules_dependencies")

      go_rules_dependencies()

      go_host_sdk(name = "go_sdk")
    EOS

    (testpath"test.go").write <<~EOS
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    EOS

    (testpath"BUILD").write <<~EOS
      load("@io_bazel_rules_gogo:def.bzl", "go_binary")

      go_binary(
        name = "bazel-test",
        srcs = glob(["*.go"])
      )
    EOS

    pid = fork { exec("ibazel", "build", ":bazel-test") }
    out_file = "bazel-binbazel-test_bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid)
    sleep 1
    Process.kill("TERM", pid)
  end
end

__END__
diff --git a.bazelversion b.bazelversion
index 8a30e8f..09b254e 100644
--- a.bazelversion
+++ b.bazelversion
@@ -1 +1 @@
-5.4.0
+6.4.0