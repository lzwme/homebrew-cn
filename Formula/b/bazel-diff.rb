class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v26.0.1.tar.gz"
  sha256 "4b06c34fc792d861848abe5c982431970ade7e2fb710f62d32120813a0bc367e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f85a064d0f545a6f40ebe0d8deffeee55650971ac14f08bde67f7d805e330d59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f85a064d0f545a6f40ebe0d8deffeee55650971ac14f08bde67f7d805e330d59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85a064d0f545a6f40ebe0d8deffeee55650971ac14f08bde67f7d805e330d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "f85a064d0f545a6f40ebe0d8deffeee55650971ac14f08bde67f7d805e330d59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30f2cd9dbfdb217d176f9f42ef4a203c1965ecdf8cfbeeeaae37cbf3c910ed37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f2cd9dbfdb217d176f9f42ef4a203c1965ecdf8cfbeeeaae37cbf3c910ed37"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
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