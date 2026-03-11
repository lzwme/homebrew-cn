class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/17.1.5.tar.gz"
  sha256 "ff8c98497ffce4e3df564e8dc0bdc954bf8b242755f8c24f4d99b2fce756050f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efb80ecc7165585feea7417643d4b16491905ec1acf17dbcb904708bfb73d6b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efb80ecc7165585feea7417643d4b16491905ec1acf17dbcb904708bfb73d6b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb80ecc7165585feea7417643d4b16491905ec1acf17dbcb904708bfb73d6b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "efb80ecc7165585feea7417643d4b16491905ec1acf17dbcb904708bfb73d6b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2282ffc2eae2dcbf8d122df606809c9bbb60a93b43936cbfff7973219c9a5293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2282ffc2eae2dcbf8d122df606809c9bbb60a93b43936cbfff7973219c9a5293"
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