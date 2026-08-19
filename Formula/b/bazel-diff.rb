class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v43.0.0.tar.gz"
  sha256 "9ad85505f39618ab560c542fc707ad7c263ebe08816f2696cce8d832bca82d9f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52a56f734d9b959a78c9cbb6809c2c70fbdbfe05da40034d66c8c5daeb85912a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a56f734d9b959a78c9cbb6809c2c70fbdbfe05da40034d66c8c5daeb85912a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52a56f734d9b959a78c9cbb6809c2c70fbdbfe05da40034d66c8c5daeb85912a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52a56f734d9b959a78c9cbb6809c2c70fbdbfe05da40034d66c8c5daeb85912a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce029a2b4c83f9958a0b889790101bf5201d69e144b03c43ab20e3a006d00c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce029a2b4c83f9958a0b889790101bf5201d69e144b03c43ab20e3a006d00c8d"
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