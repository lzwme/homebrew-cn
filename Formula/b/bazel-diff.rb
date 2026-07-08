class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v31.3.2.tar.gz"
  sha256 "95fe82e95d7f28f1997ad090be69058a4c57017ca2e80cba2f0724c5bd23c761"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3066432f5c3d640cf0d4195c0f1d7e73c173b908a055bc0c9bf99c55aa475367"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3066432f5c3d640cf0d4195c0f1d7e73c173b908a055bc0c9bf99c55aa475367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3066432f5c3d640cf0d4195c0f1d7e73c173b908a055bc0c9bf99c55aa475367"
    sha256 cellar: :any_skip_relocation, sonoma:        "3066432f5c3d640cf0d4195c0f1d7e73c173b908a055bc0c9bf99c55aa475367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63d164c1e7894b9ea5ac08525d9f823b47e0dc397c26e9ade464f1ad2ac01347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63d164c1e7894b9ea5ac08525d9f823b47e0dc397c26e9ade464f1ad2ac01347"
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