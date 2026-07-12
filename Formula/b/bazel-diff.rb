class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v33.0.0.tar.gz"
  sha256 "c96e38b9d52ec7e97920de6bfaaeb40a53f3c0f25249f0f874696685cef47b64"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41db4ae75493216f21f3f0564af65fa8af4ffc7611a1adcbc2ac3cbda4ac9b73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41db4ae75493216f21f3f0564af65fa8af4ffc7611a1adcbc2ac3cbda4ac9b73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41db4ae75493216f21f3f0564af65fa8af4ffc7611a1adcbc2ac3cbda4ac9b73"
    sha256 cellar: :any_skip_relocation, sonoma:        "41db4ae75493216f21f3f0564af65fa8af4ffc7611a1adcbc2ac3cbda4ac9b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e15d240a2c3c2c9b813d7b63fd03a61d223361e4c94f488172323964d5c0ebbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15d240a2c3c2c9b813d7b63fd03a61d223361e4c94f488172323964d5c0ebbf"
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