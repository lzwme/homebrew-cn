class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https:github.comTinderbazel-diff"
  url "https:github.comTinderbazel-diffreleasesdownload7.0.2bazel-diff_deploy.jar"
  sha256 "45357d67d450291c177fda0eea72e2a2f5c67bbe6f93143598a23973ac2166d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc21d07825c19e2c5e31ad307c457602814ebc6b8b94789dc9546a96f7435440"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58bda06d20f045abe7b083d2e68127c9ec70fbdc1dc82152e3a1fc7c02a4fd53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "007126d696950d8afdcda897c697273f01b1644b9289eb62623012e1fd0926e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "92ff06315fd9025f4a0d7c0dc05525ed9355fc017af200e9ee72ff95852136a6"
    sha256 cellar: :any_skip_relocation, ventura:        "64d23698a20b1996e94e6f5a3f3244874fc0f51309694e6e610a3088f0653a23"
    sha256 cellar: :any_skip_relocation, monterey:       "b784296452b2f0782d168e042eb16162456f30c21cf6b45fa0f64c6381e86d66"
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