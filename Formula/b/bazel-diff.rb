class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/releases/download/10.1.0/bazel-diff_deploy.jar"
  sha256 "d542aa8be9f4855001b5dde113c03b9264493bd6009444a0f80594c7acf26abe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "343815d66ea5da0a5955dd698843455b049ca478c641bd0004578debc89c84de"
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