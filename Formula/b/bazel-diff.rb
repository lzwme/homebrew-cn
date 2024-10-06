class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload7.2.14bazel-diff_deploy.jar"
  sha256 "d90278cbccb87c57fc8359ffb4c1c74b9c7b1069e777df44b6e02ef65cc95971"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "31efe6494330fc560ab7bad3c65efa46fff47a8f1bcc33acfcf3636be1e43c8c"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end