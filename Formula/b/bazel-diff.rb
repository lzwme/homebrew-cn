class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload5.0.1bazel-diff_deploy.jar"
  sha256 "eca2d221f5c3ec9545c841ed62d319bbb59e447a1ceade563bc8f8e1b9186a34"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef4a53a5730b19750630fefdcbb0d85f66c5c24b9baea05aa0e8d3461d04c3ab"
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