class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v44.0.0.tar.gz"
  sha256 "5b4a4490fd25e3561b37d172cbf7806bff3e07bf5b7fbb5efbd22e700ef914c0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e748c4e9cd9fd28df17531d2549e4dba5dfb682f34f0225f37ad31d440117317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e748c4e9cd9fd28df17531d2549e4dba5dfb682f34f0225f37ad31d440117317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e748c4e9cd9fd28df17531d2549e4dba5dfb682f34f0225f37ad31d440117317"
    sha256 cellar: :any_skip_relocation, sonoma:        "e748c4e9cd9fd28df17531d2549e4dba5dfb682f34f0225f37ad31d440117317"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71acf077053d2fc3371cfc2d0570a7b2325d4a94dc00494df9a071dfe6cfca22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71acf077053d2fc3371cfc2d0570a7b2325d4a94dc00494df9a071dfe6cfca22"
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