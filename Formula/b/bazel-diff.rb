class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v36.0.0.tar.gz"
  sha256 "f4e1236f67fbedf8a133373bd28013199bcb8b2a579aca89007a599d92f0b2fd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28e2f5641a35f24ecd62fe2ba7d4a40ba727c04994166646d020a8aa8d106e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28e2f5641a35f24ecd62fe2ba7d4a40ba727c04994166646d020a8aa8d106e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28e2f5641a35f24ecd62fe2ba7d4a40ba727c04994166646d020a8aa8d106e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b28e2f5641a35f24ecd62fe2ba7d4a40ba727c04994166646d020a8aa8d106e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa69130c2ebc87866c575fdd7cadd5396e32f7fa636e1544d0e1d7cc3bbce3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa69130c2ebc87866c575fdd7cadd5396e32f7fa636e1544d0e1d7cc3bbce3fc"
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