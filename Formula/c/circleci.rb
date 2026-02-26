class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.34685",
      revision: "d72a81c38df991bce6119d0e5ad76d1bf12ffc5a"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "205a14cb9edc45c2bae119e4618ec559fcaacd6632070fd745db4e1d96f2f958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3e9d610870e295f232c43fc4612b7c89a2cdf230570eeed7757c6dd67ab47f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "485fae64c0e40d3a99e8afb5b6cfaafbb6e7125e4f276210b749867a27e7064d"
    sha256 cellar: :any_skip_relocation, sonoma:        "293d6973d4ca255b0e7df1356e482e6ac1f70d64dc98854e3a960dcc128af40f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c29df54a274e6e85e33f62ad1eacb17dd155b9c16df4b527f9c0f22d1884b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d0cd6df050336d25ebb37fa6db1269ae221db9b2a4113141f961c33f18886f5"
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