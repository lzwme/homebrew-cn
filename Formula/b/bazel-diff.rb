class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/releases/download/12.1.2/bazel-diff_deploy.jar"
  sha256 "34567eb96afbdc06d0e0c70262b488002a152cd990fb95a23ae36bc9bca22d39"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08da291bbc23f0a940ddbd69920a9508a9e65f5f70450f3ae2d66a6706883eeb"
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