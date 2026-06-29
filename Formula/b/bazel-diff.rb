class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v29.0.0.tar.gz"
  sha256 "a35b2238be23e24471cda486a9ddaf351df1e54b5ae6e7cb0919d42ec0f7d2a8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa48fbd53d278067a41757afa939b9c0c5f3423390c9df40a42d0ad12d3cc5ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa48fbd53d278067a41757afa939b9c0c5f3423390c9df40a42d0ad12d3cc5ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa48fbd53d278067a41757afa939b9c0c5f3423390c9df40a42d0ad12d3cc5ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa48fbd53d278067a41757afa939b9c0c5f3423390c9df40a42d0ad12d3cc5ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321854e3298530682c707bc86ff6f28936996bfec517e6ebc11c45233bc7cfc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "321854e3298530682c707bc86ff6f28936996bfec517e6ebc11c45233bc7cfc1"
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