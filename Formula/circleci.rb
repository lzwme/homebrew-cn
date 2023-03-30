class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.25519",
      revision: "8b2a4d0a5ffbfb298d785ca8d39d5807cddf37da"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89a7b67656661f5085620d9f6e8982f5edbdc92847be1f5f295b456396ac59bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89a7b67656661f5085620d9f6e8982f5edbdc92847be1f5f295b456396ac59bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89a7b67656661f5085620d9f6e8982f5edbdc92847be1f5f295b456396ac59bb"
    sha256 cellar: :any_skip_relocation, ventura:        "895b93f7206ad538a1fea1c3b93026c28c774ffc31ba74f8aa88ecc947b28b7b"
    sha256 cellar: :any_skip_relocation, monterey:       "895b93f7206ad538a1fea1c3b93026c28c774ffc31ba74f8aa88ecc947b28b7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "895b93f7206ad538a1fea1c3b93026c28c774ffc31ba74f8aa88ecc947b28b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf6f6ae75cc2517b2eb19f949b752c9d2121fabacdbd13aa191b42cdad4e46bb"
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