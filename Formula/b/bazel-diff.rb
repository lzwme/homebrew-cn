class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload7.2.15bazel-diff_deploy.jar"
  sha256 "d90278cbccb87c57fc8359ffb4c1c74b9c7b1069e777df44b6e02ef65cc95971"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a475afd5b51cc9dedd075a324771290fe12be0b8dc4952dc1d3507b68b447ab"
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