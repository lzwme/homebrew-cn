class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v32.0.1.tar.gz"
  sha256 "1effc93bec2e49b345cde151d12c75e5bbc11c6ba35af82b64858fee9451ffc8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d392c67bafaf9f826c260cad3f76e6c84241a3bf5c5326f9c003a0b5ce16d5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d392c67bafaf9f826c260cad3f76e6c84241a3bf5c5326f9c003a0b5ce16d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d392c67bafaf9f826c260cad3f76e6c84241a3bf5c5326f9c003a0b5ce16d5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d392c67bafaf9f826c260cad3f76e6c84241a3bf5c5326f9c003a0b5ce16d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f6b9f8187f299da3ed188e2d0b0f570b612a88f8c230688217d03b827eaeb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f6b9f8187f299da3ed188e2d0b0f570b612a88f8c230688217d03b827eaeb75"
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