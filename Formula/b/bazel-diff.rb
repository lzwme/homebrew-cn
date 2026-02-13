class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/releases/download/13.0.0/bazel-diff_deploy.jar"
  sha256 "e0724edee9e421e027d34e9057b9fee723d4d5bed6c38d2c5010cb10263d6e69"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ef4a91a5fbea82d3c9f8cd789fbae2434bc50c6a37731e1d572c74b13cec567"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end