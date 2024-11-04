class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload8.1.3bazel-diff_deploy.jar"
  sha256 "1dffcfbde66d5109b11fdcc58a44ffc0f1a33de7a68115b63e22bc973e011613"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59438feaf0ce17fdb0ae5f9f639ec1f7cd1fb4ce0a326e6000bc1c754b2fb8f4"
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