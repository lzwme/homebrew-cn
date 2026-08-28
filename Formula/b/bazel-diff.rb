class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v46.0.0.tar.gz"
  sha256 "ba3aed6171841da892a839a2065164c206f522ef713f833205c431b35296e0d6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ff2136067413ead6d43e5bbc602cf6a35d80319c69f6bf2a40ebfa433b55c0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ff2136067413ead6d43e5bbc602cf6a35d80319c69f6bf2a40ebfa433b55c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ff2136067413ead6d43e5bbc602cf6a35d80319c69f6bf2a40ebfa433b55c0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8061d2bfbec6562105cade7d8b22902f83361910737125b812f9494565cb52af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8061d2bfbec6562105cade7d8b22902f83361910737125b812f9494565cb52af"
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