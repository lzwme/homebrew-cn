class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/releases/download/15.0.4/release.tar.gz"
  sha256 "3dcbf162e9d287378edfcbf5f0008cd3f0f1bbe709aa3729f0d23c4601bc070f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24583075c106993aa04ef1fe6197588db95c0617fd338ee18cda68e24e833973"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24583075c106993aa04ef1fe6197588db95c0617fd338ee18cda68e24e833973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24583075c106993aa04ef1fe6197588db95c0617fd338ee18cda68e24e833973"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c372b1b63877281ac6f6f37200c2e4db9c963350fd9a2c9ae1958f31120aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee9cd33cc65839e5342dd802d4b3a67c87c61fdd11624e1e582cadc0de3315f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1622b43fa22dfb39fb9f46b6ae6c6de692439434b64ee36ce9ac999ac4a0969"
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