class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload9.0.5bazel-diff_deploy.jar"
  sha256 "fc43012fa58ee7ceb286dcf3673e8c0f6fd38dbc08e73b331c515bfc6cb26a63"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "421b88a8816359c1f50c263e7b2c7045fc39b30ca232c27dcb5c8fbb14998dc0"
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