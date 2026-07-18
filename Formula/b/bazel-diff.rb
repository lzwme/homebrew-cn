class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v35.0.0.tar.gz"
  sha256 "4544d2dd6060843ad37fc2769003309710c5350efb9fd41a92a0d71f56a19463"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dd7b6789dc914afded52fb539630bbdd7f774cb115308c5f642e77809a574d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd7b6789dc914afded52fb539630bbdd7f774cb115308c5f642e77809a574d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd7b6789dc914afded52fb539630bbdd7f774cb115308c5f642e77809a574d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dd7b6789dc914afded52fb539630bbdd7f774cb115308c5f642e77809a574d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc980f5eef8c3f5087a1defd7e1e9d54c2e764d36373d3b58c7edd855c30c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc980f5eef8c3f5087a1defd7e1e9d54c2e764d36373d3b58c7edd855c30c03"
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