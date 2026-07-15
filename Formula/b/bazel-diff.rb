class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v34.0.0.tar.gz"
  sha256 "e6ba8df7aa277efaeacb760cbc4bababd88327e8f08de9096ddd0095108f7628"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d85db6f1fbc65cd7d0a4a410a8cf2ce632532845f4c699f17a1ea1ff68a19132"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d85db6f1fbc65cd7d0a4a410a8cf2ce632532845f4c699f17a1ea1ff68a19132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d85db6f1fbc65cd7d0a4a410a8cf2ce632532845f4c699f17a1ea1ff68a19132"
    sha256 cellar: :any_skip_relocation, sonoma:        "d85db6f1fbc65cd7d0a4a410a8cf2ce632532845f4c699f17a1ea1ff68a19132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9157bbd0d2e6daa1c0e230a7b1c5d8f9bed9d52dc09ebe4512de3dcdb6b846bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9157bbd0d2e6daa1c0e230a7b1c5d8f9bed9d52dc09ebe4512de3dcdb6b846bf"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    rm ".bazelversion"

    extra_bazel_args = %w[
      -c opt
      --@protobuf//bazel/toolchains:prefer_prebuilt_protoc
      --enable_bzlmod
      --java_runtime_version=local_jdk
      --tool_java_runtime_version=local_jdk
      --repo_contents_cache=
    ]

    system "bazel", "build", *extra_bazel_args, "//cli:bazel-diff_deploy.jar"

    libexec.install "bazel-bin/cli/bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end