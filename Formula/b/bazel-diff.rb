class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v23.0.0.tar.gz"
  sha256 "8ef2a8674ff96008586e3d840dac793112f2968f664a5cf4a146c596f0ab3617"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a366dbf89678ba7d616317691111e71676905906bb83c3cfdc1bb934ec978b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a366dbf89678ba7d616317691111e71676905906bb83c3cfdc1bb934ec978b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a366dbf89678ba7d616317691111e71676905906bb83c3cfdc1bb934ec978b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "a366dbf89678ba7d616317691111e71676905906bb83c3cfdc1bb934ec978b28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e82b5f7b64b532ae8a4c1b834342d7ae27a9040697c3248676c97ca5db9d6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e82b5f7b64b532ae8a4c1b834342d7ae27a9040697c3248676c97ca5db9d6c3"
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