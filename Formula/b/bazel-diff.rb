class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v20.0.0.tar.gz"
  sha256 "15076b062acda59391fc0c8757a4183d3c8beded47208424818e4e3c56b3e52b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "321b157f51fbc129ddbd708a271af2d48f8d4b78aeaff5493bdf70d783889f19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "321b157f51fbc129ddbd708a271af2d48f8d4b78aeaff5493bdf70d783889f19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "321b157f51fbc129ddbd708a271af2d48f8d4b78aeaff5493bdf70d783889f19"
    sha256 cellar: :any_skip_relocation, sonoma:        "321b157f51fbc129ddbd708a271af2d48f8d4b78aeaff5493bdf70d783889f19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd13a95081fd0aace29af188b04d8a6c5d531f3b6a4d05373993cfb01facc9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd13a95081fd0aace29af188b04d8a6c5d531f3b6a4d05373993cfb01facc9b0"
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