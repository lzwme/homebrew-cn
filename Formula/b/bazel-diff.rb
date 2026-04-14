class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v18.0.5.tar.gz"
  sha256 "d328de8d4ae6ae337625ac62954a0de9776a2a026a534bc542bfcabd3467eb61"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c6f2d037796ae1d809f7c08556ca134772edb0134d4221f2169266923e10a9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6f2d037796ae1d809f7c08556ca134772edb0134d4221f2169266923e10a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c6f2d037796ae1d809f7c08556ca134772edb0134d4221f2169266923e10a9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c6f2d037796ae1d809f7c08556ca134772edb0134d4221f2169266923e10a9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8bef2f6c26d8dd835548af9947f3d14074c353100bfad8a6ea32fa32b8ef0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e8bef2f6c26d8dd835548af9947f3d14074c353100bfad8a6ea32fa32b8ef0c"
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