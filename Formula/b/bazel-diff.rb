class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v41.0.0.tar.gz"
  sha256 "68fbb12818daf5e72f544337937d49ce6cc8bcae9098e707081620226e7f9192"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b786f220d6845d0432640809ee7ebcc820f852b5415335e7c36fe9317896dfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b786f220d6845d0432640809ee7ebcc820f852b5415335e7c36fe9317896dfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b786f220d6845d0432640809ee7ebcc820f852b5415335e7c36fe9317896dfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b786f220d6845d0432640809ee7ebcc820f852b5415335e7c36fe9317896dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8563598c15752df5a2f1b88ae825874e66139d4c7fbcd6b4293d738d89442fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8563598c15752df5a2f1b88ae825874e66139d4c7fbcd6b4293d738d89442fd6"
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