class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.26646",
      revision: "63d68f9273387e741b26fb743d45d4a45baebe00"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa1011762d7a021caed59782092e0826757258a7c9671ffa7df05c1c550c13f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa1011762d7a021caed59782092e0826757258a7c9671ffa7df05c1c550c13f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa1011762d7a021caed59782092e0826757258a7c9671ffa7df05c1c550c13f6"
    sha256 cellar: :any_skip_relocation, ventura:        "ee17b4d17f3c55d63f5c553d941a50b37ce549652a458f1c54d861de9e7c9815"
    sha256 cellar: :any_skip_relocation, monterey:       "ee17b4d17f3c55d63f5c553d941a50b37ce549652a458f1c54d861de9e7c9815"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee17b4d17f3c55d63f5c553d941a50b37ce549652a458f1c54d861de9e7c9815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "184e084b00c4dd620c9a42eb5aef1443826c1b209ab43eb7d5e2493c55d04dc3"
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