class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/releases/download/16.0.0/release.tar.gz"
  sha256 "6baf16fee77f36f9a69fe972e28bf600cc92f28d01850a97ee9f39a23b5d7534"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f7e1f48189b485e03ba2dd2e4ed918330c48d6aecd5917b2c9d037ac0092bca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f7e1f48189b485e03ba2dd2e4ed918330c48d6aecd5917b2c9d037ac0092bca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f7e1f48189b485e03ba2dd2e4ed918330c48d6aecd5917b2c9d037ac0092bca"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca6acad2d8e668632a1fd9a625dbee24d01b3557285dfae3c3979c17c613ef4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9dfd934f9081c812898ef3ad6a6a4e2ec5d2a3d43e926fea418cffcff81031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bceacdd3c64531039366a63f61dd4cf725569139367402d655a282fbce92346d"
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