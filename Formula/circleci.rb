class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.25569",
      revision: "ee2797e8280befbb11d9586c073302d9597b5a3f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7f173b5ab6cefc3dbf7b0d0d81f547643acd46d5e7da57a2a259c953d5610c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7f173b5ab6cefc3dbf7b0d0d81f547643acd46d5e7da57a2a259c953d5610c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7f173b5ab6cefc3dbf7b0d0d81f547643acd46d5e7da57a2a259c953d5610c3"
    sha256 cellar: :any_skip_relocation, ventura:        "4363592b93c35f83133c1c8b8f153d92e9e52ef560e23cebcf34e63d07ed0840"
    sha256 cellar: :any_skip_relocation, monterey:       "4363592b93c35f83133c1c8b8f153d92e9e52ef560e23cebcf34e63d07ed0840"
    sha256 cellar: :any_skip_relocation, big_sur:        "4363592b93c35f83133c1c8b8f153d92e9e52ef560e23cebcf34e63d07ed0840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1208a70f30336759e08d1903bb547c57742a1ae46b36003a22c843ba0d7eff"
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