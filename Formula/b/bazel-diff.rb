class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload7.2.0bazel-diff_deploy.jar"
  sha256 "7c06599cc386185e5128fbfa4b553dce8b8d063ffd7ae1671cc49a8726d28c33"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a47ad86c9229b771103e710875560fe2e1268f8d31048e694d5fdc0d4b664b6"
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