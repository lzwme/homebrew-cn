class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.25638",
      revision: "ed408fb3c130e7cb22fca11c007da0f94d1f12a3"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4df23daaa6e126179d815a6d2a70eaa42fce5023687331e7bec1e7e8bf597a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4df23daaa6e126179d815a6d2a70eaa42fce5023687331e7bec1e7e8bf597a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4df23daaa6e126179d815a6d2a70eaa42fce5023687331e7bec1e7e8bf597a6"
    sha256 cellar: :any_skip_relocation, ventura:        "9e61b6e8b1af26df8215c21c6e62665f88b823f7f7d7ca8155512484ef560693"
    sha256 cellar: :any_skip_relocation, monterey:       "9e61b6e8b1af26df8215c21c6e62665f88b823f7f7d7ca8155512484ef560693"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e61b6e8b1af26df8215c21c6e62665f88b823f7f7d7ca8155512484ef560693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec1cab4702b7ef95396ef93d25c72aec8bd89efd14ccf9312ecec687ed624624"
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