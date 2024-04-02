class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload7.0.0bazel-diff_deploy.jar"
  sha256 "0b9e32f9c20e570846b083743fe967ae54d13e2a1f7364983e0a7792979442be"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9672cf53a6a555f7f4b3ee0e8804ebd239c54c531da74c57affcdb96fe4e2cf"
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