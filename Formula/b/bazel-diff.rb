class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v39.0.0.tar.gz"
  sha256 "c3eb056ccbe89245d49cb05317a29ff3eed46a87679f344e529ef1c0cba2b347"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe487e80b01f9813a516669ab5e3547d561f1c4e6d81c42b43f80672ecedbc51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe487e80b01f9813a516669ab5e3547d561f1c4e6d81c42b43f80672ecedbc51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe487e80b01f9813a516669ab5e3547d561f1c4e6d81c42b43f80672ecedbc51"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe487e80b01f9813a516669ab5e3547d561f1c4e6d81c42b43f80672ecedbc51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6351e49a255d0dee398c79f1ea7b8adc3561d319ac7ac0de5b4171797a67bbfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6351e49a255d0dee398c79f1ea7b8adc3561d319ac7ac0de5b4171797a67bbfb"
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