class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.25007",
      revision: "8abc86a1a8941f69891431ec58949c1befc53eb7"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe7427c762c67a1cd0bc7a75fa4b84b2b6c6e18bcf2c5b80a2a9615737c9b384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe7427c762c67a1cd0bc7a75fa4b84b2b6c6e18bcf2c5b80a2a9615737c9b384"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe7427c762c67a1cd0bc7a75fa4b84b2b6c6e18bcf2c5b80a2a9615737c9b384"
    sha256 cellar: :any_skip_relocation, ventura:        "f18f68aaf30c904d329d9febea6d0f5e5edbc2f781901b5476647632731ccf25"
    sha256 cellar: :any_skip_relocation, monterey:       "f18f68aaf30c904d329d9febea6d0f5e5edbc2f781901b5476647632731ccf25"
    sha256 cellar: :any_skip_relocation, big_sur:        "f18f68aaf30c904d329d9febea6d0f5e5edbc2f781901b5476647632731ccf25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9be21051ffa458b2d6191838d5d54995d9fd8e53a27ce6f86a3691301f561bce"
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