class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v24.0.0.tar.gz"
  sha256 "f7e2edfe85127f6f228688c94ce279b5e4b26a188d80b0c4aae55c9097636b0e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea69d90dde28839d4010863851c0a19507555cf8cd2fae934f1ca690eb46e306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea69d90dde28839d4010863851c0a19507555cf8cd2fae934f1ca690eb46e306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea69d90dde28839d4010863851c0a19507555cf8cd2fae934f1ca690eb46e306"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea69d90dde28839d4010863851c0a19507555cf8cd2fae934f1ca690eb46e306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ba494e81c29e97ea86573fc942e48ac8f991d424c6a72befe847df8b070a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64ba494e81c29e97ea86573fc942e48ac8f991d424c6a72befe847df8b070a3d"
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