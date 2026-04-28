class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.35800",
      revision: "bb129029cfdc48d00dacff17fd8dcdaaa67e58f3"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0703ee9aff329dc3e3ef793c1f9559d31dda443d29c09d117e6daa429b646f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52763d39564aab463e8312f566970bec59dcc1db7a8f1539a75f6b1d54e03b41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71471a14773c850ca7f0318ecbbd76ae2a1425044db66971366f0c4fd7ad5908"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1bde638429a4d7ff8d928c2b05ffd7570603da4b61eb4aa37f81c0f2ef9f303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3e002dc0d11c9e006de6c357d33d471acca40e51f89b424e64616bb7a3a0db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c6b25e9ced6b692c6b5a9cef0aef39f7a5b100d9c25c485228855323c5ffbef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=#{tap.user.downcase}
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags:)

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