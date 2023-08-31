class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghproxy.com/https://github.com/Tinder/bazel-diff/releases/download/4.8.1/bazel-diff_deploy.jar"
  sha256 "1a7afe747558a217670a60f51f4d0d5bd3a99cb843f9abd4db6b5af9a4920dc1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1b4f17aaadffb067f7a368d5199b071ae3e030c61e96d11be46be54768b1169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1b4f17aaadffb067f7a368d5199b071ae3e030c61e96d11be46be54768b1169"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1b4f17aaadffb067f7a368d5199b071ae3e030c61e96d11be46be54768b1169"
    sha256 cellar: :any_skip_relocation, ventura:        "d1b4f17aaadffb067f7a368d5199b071ae3e030c61e96d11be46be54768b1169"
    sha256 cellar: :any_skip_relocation, monterey:       "d1b4f17aaadffb067f7a368d5199b071ae3e030c61e96d11be46be54768b1169"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b4f17aaadffb067f7a368d5199b071ae3e030c61e96d11be46be54768b1169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4598eee02c7be231d533780048f53f61897b7976ff408df587d6c337b9f6661a"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "Unexpected error during generation of hashes", output
  end
end