class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload7.2.3bazel-diff_deploy.jar"
  sha256 "9a21fbd1322c731f5b21270d6a2da776ac7d02e9c62d9a22b6e1737c9963e059"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83fe9957a0ffa44797753d7f10058ae4def8c4151d61085abe1472255279f5bc"
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