class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload8.1.1bazel-diff_deploy.jar"
  sha256 "42334bd889a5941926d86adc903e4f8338d8873d70c457b91538fef7c9a63124"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb562a7013f2f4d5119f43df12fe5871247fded6a1bdbe7d5dd08f01195a3efb"
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