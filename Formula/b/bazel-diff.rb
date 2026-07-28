class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v38.0.0.tar.gz"
  sha256 "bfa0672dd5e7ae7ba0c09f098231dae90d2f098aa629e30c86c2d8237b71a37d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ce78faae6ecad088dcfcd98ec062458eeb4ad02f4e0fea9110e2995d3bc09b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16ce78faae6ecad088dcfcd98ec062458eeb4ad02f4e0fea9110e2995d3bc09b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ce78faae6ecad088dcfcd98ec062458eeb4ad02f4e0fea9110e2995d3bc09b"
    sha256 cellar: :any_skip_relocation, sonoma:        "16ce78faae6ecad088dcfcd98ec062458eeb4ad02f4e0fea9110e2995d3bc09b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a20d5444865e2d17b95ccf3299352e0312f9809aee849210c2a6d3ccf7641b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a20d5444865e2d17b95ccf3299352e0312f9809aee849210c2a6d3ccf7641b"
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