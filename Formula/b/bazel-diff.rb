class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v26.0.0.tar.gz"
  sha256 "ec3738d8c256250dd85ed3b44fbd2d7bf676e56cdfb57fc07e59049465e5d2c4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66afccb21bf3290816ed965a8faee82d046201980380e880cf762a3ecd552e62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66afccb21bf3290816ed965a8faee82d046201980380e880cf762a3ecd552e62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66afccb21bf3290816ed965a8faee82d046201980380e880cf762a3ecd552e62"
    sha256 cellar: :any_skip_relocation, sonoma:        "66afccb21bf3290816ed965a8faee82d046201980380e880cf762a3ecd552e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65976addaf0e68b83ad3c70a5e980003997d6dd6e8d49d6586caaf163382a3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65976addaf0e68b83ad3c70a5e980003997d6dd6e8d49d6586caaf163382a3fb"
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