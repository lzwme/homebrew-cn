class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v46.1.0.tar.gz"
  sha256 "b031e8e793e06e46c94a18168d43f87937566ba657db9329da18218bcbf73df3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "041d7b1fdacee9d17ca168ddd002fa61c7bb8a1dcb28b40733506cf38f70fc43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "041d7b1fdacee9d17ca168ddd002fa61c7bb8a1dcb28b40733506cf38f70fc43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "041d7b1fdacee9d17ca168ddd002fa61c7bb8a1dcb28b40733506cf38f70fc43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "932c8c0f1dc3350784550fb6056256ea1f1be6dd94c56e0c86d005679eaa3b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "932c8c0f1dc3350784550fb6056256ea1f1be6dd94c56e0c86d005679eaa3b38"
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