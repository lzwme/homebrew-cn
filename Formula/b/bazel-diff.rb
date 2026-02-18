class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/releases/download/14.0.0/bazel-diff_deploy.jar"
  sha256 "bbc59c84c1b6425a510d1ed5fb82a6086742914ee402217abbdfbc8c8c60a8a7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ceab528289d85a042393e1feebe3ac21b99509ed9cceeb047b88b980430464a"
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