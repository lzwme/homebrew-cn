class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v34.0.1.tar.gz"
  sha256 "0d445bfe88e5cf72fb7ed277389f1dd09dcdf79e7aa888c9d3a759834d80bbae"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d007fe1a836d388ea76eba3c4e72b6b7e95f2e478ae60fe490497259501f2a45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d007fe1a836d388ea76eba3c4e72b6b7e95f2e478ae60fe490497259501f2a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d007fe1a836d388ea76eba3c4e72b6b7e95f2e478ae60fe490497259501f2a45"
    sha256 cellar: :any_skip_relocation, sonoma:        "d007fe1a836d388ea76eba3c4e72b6b7e95f2e478ae60fe490497259501f2a45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac8cbcc0dbab0a59e7718fbcf86338eeb00ca917729ee952218c894b29789c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac8cbcc0dbab0a59e7718fbcf86338eeb00ca917729ee952218c894b29789c6"
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