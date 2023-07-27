class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.28084",
      revision: "458f94e02dce1ea0eb4fe608cd2943a32de9578e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc043aeb3ff040a59321e17404bcbff0d097879b9337a82d7b192c1da57998d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc043aeb3ff040a59321e17404bcbff0d097879b9337a82d7b192c1da57998d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc043aeb3ff040a59321e17404bcbff0d097879b9337a82d7b192c1da57998d2"
    sha256 cellar: :any_skip_relocation, ventura:        "8bef687936a226ba8b91950d6cc1c5894c7877002afaf9759238e77676322515"
    sha256 cellar: :any_skip_relocation, monterey:       "8bef687936a226ba8b91950d6cc1c5894c7877002afaf9759238e77676322515"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bef687936a226ba8b91950d6cc1c5894c7877002afaf9759238e77676322515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aae722fcad47aa9259e85beb2f572e294d20dfe7a648044069f9764b67bc965"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end