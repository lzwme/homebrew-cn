class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v39.0.1.tar.gz"
  sha256 "5af9be760629f929575a48470257b1fef1e2aec325606a2124a30cac0ddad9a0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "469cc4efffe00c055a20804d7d3b9a019b6ddde2f48cea6e74dba9260e5cae88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469cc4efffe00c055a20804d7d3b9a019b6ddde2f48cea6e74dba9260e5cae88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469cc4efffe00c055a20804d7d3b9a019b6ddde2f48cea6e74dba9260e5cae88"
    sha256 cellar: :any_skip_relocation, sonoma:        "469cc4efffe00c055a20804d7d3b9a019b6ddde2f48cea6e74dba9260e5cae88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "681c248b5b5b22715644b7b1c21f7f4063cd59b3e940e93d37d52d8c6a9b61b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681c248b5b5b22715644b7b1c21f7f4063cd59b3e940e93d37d52d8c6a9b61b5"
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