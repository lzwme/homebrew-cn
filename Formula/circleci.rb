class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.25848",
      revision: "cbe4c3121d46e5daaaf7be8f093dcbf6ae19a758"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0de6d41971af0168b8ef23e6df6e026737de3e1e60da897533be8a8970700351"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de6d41971af0168b8ef23e6df6e026737de3e1e60da897533be8a8970700351"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0de6d41971af0168b8ef23e6df6e026737de3e1e60da897533be8a8970700351"
    sha256 cellar: :any_skip_relocation, ventura:        "b729d1d42bbcc74c0438073282f34da69286fd1829c408c27cd344ce33350604"
    sha256 cellar: :any_skip_relocation, monterey:       "b729d1d42bbcc74c0438073282f34da69286fd1829c408c27cd344ce33350604"
    sha256 cellar: :any_skip_relocation, big_sur:        "b729d1d42bbcc74c0438073282f34da69286fd1829c408c27cd344ce33350604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5ded6b4f74dbf7de4d629dfb0451e3fc2bd0035232dc3a823fd799f1ff19c5"
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