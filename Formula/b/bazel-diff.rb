class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v40.0.2.tar.gz"
  sha256 "729181a555e600800784bc9b5d40c8f8a75365ca31867aad559ffc014c4bf90a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3c5672722b9a4367c6535bd3dce38e33a4b449c52711a371550b4cfb0ada18b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3c5672722b9a4367c6535bd3dce38e33a4b449c52711a371550b4cfb0ada18b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c5672722b9a4367c6535bd3dce38e33a4b449c52711a371550b4cfb0ada18b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3c5672722b9a4367c6535bd3dce38e33a4b449c52711a371550b4cfb0ada18b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd560f4949610ff1f1af4999e76612c0f1fc54d161b4b16a028b3de7ea7b230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddd560f4949610ff1f1af4999e76612c0f1fc54d161b4b16a028b3de7ea7b230"
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