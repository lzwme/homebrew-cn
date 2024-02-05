class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload5.1.0bazel-diff_deploy.jar"
  sha256 "02684250b5279c88afe4fc1e21e1724c2bba9dc3b7d19830b5a4d76d61dca663"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b321275f64e36ebe96a3c9a7bd0a986ee65786e5bb36a342abb3bd244eb6ef6"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "Unexpected error during generation of hashes", output
  end
end