class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload7.2.1bazel-diff_deploy.jar"
  sha256 "d1431d53de24f07809841e177de5a0e2443c6d3279fb934ea28c2ef2406f5403"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "13c719faf44c1286a0d3e4416a3b77119cfd34b58650c51a3c1efe391884ae3c"
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