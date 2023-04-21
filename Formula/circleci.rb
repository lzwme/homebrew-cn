class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.26061",
      revision: "6ee20fd04ac56a0c44ed5d5a311981cfbad4da11"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee7ff496cb0e73a5414e0d2a15d2f5dd33b0d0e7773ce431cc213ae213ac5c35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7ff496cb0e73a5414e0d2a15d2f5dd33b0d0e7773ce431cc213ae213ac5c35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee7ff496cb0e73a5414e0d2a15d2f5dd33b0d0e7773ce431cc213ae213ac5c35"
    sha256 cellar: :any_skip_relocation, ventura:        "0c8dd16d5efabe60e01b0149ccb6fb10a7525f7549e0895970a5eba621ff9d7d"
    sha256 cellar: :any_skip_relocation, monterey:       "0c8dd16d5efabe60e01b0149ccb6fb10a7525f7549e0895970a5eba621ff9d7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c8dd16d5efabe60e01b0149ccb6fb10a7525f7549e0895970a5eba621ff9d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d546f3049903e1d5b06794d34fadd6efef25a1e28d851bb09e15724ede5440"
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
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end