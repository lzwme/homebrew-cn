class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.28196",
      revision: "0fd0133721c20a21e8a062ae6fe3ff8bca18fc69"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5729772340c4a22e3e9b3fdbeba1d9fe0bd58a49a2a642f68b37d3bfb708198"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5729772340c4a22e3e9b3fdbeba1d9fe0bd58a49a2a642f68b37d3bfb708198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5729772340c4a22e3e9b3fdbeba1d9fe0bd58a49a2a642f68b37d3bfb708198"
    sha256 cellar: :any_skip_relocation, ventura:        "b4207aac21ec1a735a2ab333857cc07c10fa9faff6defc1d7f55843819a856bc"
    sha256 cellar: :any_skip_relocation, monterey:       "b4207aac21ec1a735a2ab333857cc07c10fa9faff6defc1d7f55843819a856bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4207aac21ec1a735a2ab333857cc07c10fa9faff6defc1d7f55843819a856bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "988d2959e2c16adab684bb9c2fb8b11bdcbd67defbe6c6e02b3d0255d911d129"
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