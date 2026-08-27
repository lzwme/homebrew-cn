class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v45.0.2.tar.gz"
  sha256 "e0510eb15182900350a7efbcec0b78acf8ac4c86bb5414562e525c2c2271688d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f65d30264ad3fefd0b5ade4a50023086378b8aa82885e89222861bd60be62f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f65d30264ad3fefd0b5ade4a50023086378b8aa82885e89222861bd60be62f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f65d30264ad3fefd0b5ade4a50023086378b8aa82885e89222861bd60be62f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f65d30264ad3fefd0b5ade4a50023086378b8aa82885e89222861bd60be62f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2650169e48fe76103d7bc1298abf569de19a80c8c8ff9848e9875e6cb01eb4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2650169e48fe76103d7bc1298abf569de19a80c8c8ff9848e9875e6cb01eb4dc"
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