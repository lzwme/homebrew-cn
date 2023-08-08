class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.28528",
      revision: "83956f7f724ca1da625034c3be033b4a5bd03b05"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cecab1e1767cfb6b40adf82748bd48cac58607f7b7a73020c79d36c8a561ff1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cecab1e1767cfb6b40adf82748bd48cac58607f7b7a73020c79d36c8a561ff1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cecab1e1767cfb6b40adf82748bd48cac58607f7b7a73020c79d36c8a561ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "31a594b32daf365100b6dcd976952973c1feed708d1981a9ba24c3740f84de1f"
    sha256 cellar: :any_skip_relocation, monterey:       "31a594b32daf365100b6dcd976952973c1feed708d1981a9ba24c3740f84de1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "31a594b32daf365100b6dcd976952973c1feed708d1981a9ba24c3740f84de1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26539d4559e974e7e2a4050bd17c36f8d7c6a07267f8f14967bb70d289ec424c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
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