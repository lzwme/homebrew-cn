class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v34.0.2.tar.gz"
  sha256 "611a188d1a1992b8b62ac8bd4d82d0e3dd13f799d668f10cd82b59b3215ca9f4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f3565f5eae760170886fbd7d63fbcba3e09a2b9d3fe7ae56efa64875d25fb37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f3565f5eae760170886fbd7d63fbcba3e09a2b9d3fe7ae56efa64875d25fb37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f3565f5eae760170886fbd7d63fbcba3e09a2b9d3fe7ae56efa64875d25fb37"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3565f5eae760170886fbd7d63fbcba3e09a2b9d3fe7ae56efa64875d25fb37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372ce2d7c24eb99a50defd537cd54991cf3dcc02e76418136ed99bd3159cb127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372ce2d7c24eb99a50defd537cd54991cf3dcc02e76418136ed99bd3159cb127"
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