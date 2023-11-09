class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.29314",
      revision: "148495aac653d6036ac93418a0ac75fd75b41518"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc6175e5471153c8cdfbe94095cba808d2ac8786bb08980869861b720e1590aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "515bb30922080f8e5e88a3f039de10f2925043471741bbb8521f6a281b78bffa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfe31737617111994b77a8dbad23c176ab2df930419226d3f6fe99d73b7068b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc173bedc8a32e830246e03f764266648c5d397f634b962af537c58282f8c689"
    sha256 cellar: :any_skip_relocation, ventura:        "9536e2435f867ff3c9b547122cb5803387d4401f4fcc9f4817904dbc0940b1d0"
    sha256 cellar: :any_skip_relocation, monterey:       "538a5971b6f5af6f920b648f12739cc36867ca62e7c675d3dcda84b3394ad395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ea56e40095282db63f909b870379b70ab9db613ad2fc013477128ee095ccc1"
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