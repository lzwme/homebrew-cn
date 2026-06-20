class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v27.0.0.tar.gz"
  sha256 "846302de9cb732215c113b841aa5864776872ce1388f3b31dd75686d9f11c43d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef7be80ce50416bd4c83115f41a9853391155a318d29c3fbc962ee354671e448"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef7be80ce50416bd4c83115f41a9853391155a318d29c3fbc962ee354671e448"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7be80ce50416bd4c83115f41a9853391155a318d29c3fbc962ee354671e448"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef7be80ce50416bd4c83115f41a9853391155a318d29c3fbc962ee354671e448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8f6f17a77a41c981d80696ed84ee5ae91015592cd443c34dfcd2a0f9e852b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f6f17a77a41c981d80696ed84ee5ae91015592cd443c34dfcd2a0f9e852b17"
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