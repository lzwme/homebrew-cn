class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload9.0.1bazel-diff_deploy.jar"
  sha256 "79291fa7b5900b98cd495bf94559ac096f2bf5341fea96425993ee19d9285e83"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86bb4d78b24b7d2114926ebb5a41f3f8616eca291f3ea563bfc0210175a2d652"
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