class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.32367",
      revision: "16777db75e7658684c7beedccfe0028aab9206b6"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a530caf6cba45160560a0c65b62aed98f9692fe5497b985983ccf7fdcc4bf29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a530caf6cba45160560a0c65b62aed98f9692fe5497b985983ccf7fdcc4bf29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a530caf6cba45160560a0c65b62aed98f9692fe5497b985983ccf7fdcc4bf29"
    sha256 cellar: :any_skip_relocation, sonoma:        "a492127bcec28ea03b9101cb2f894f066f95dcc291a125b3b55ffc6e9f460686"
    sha256 cellar: :any_skip_relocation, ventura:       "a492127bcec28ea03b9101cb2f894f066f95dcc291a125b3b55ffc6e9f460686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2930ea50b61a985b357585e52b1b6f02f9e76ed919c36dacf4d987ef80b01e01"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comCircleCI-Publiccircleci-cliversion.packageManager=#{tap.user.downcase}
      -X github.comCircleCI-Publiccircleci-cliversion.Version=#{version}
      -X github.comCircleCI-Publiccircleci-cliversion.Commit=#{Utils.git_short_head}
      -X github.comCircleCI-Publiccircleci-clitelemetry.SegmentEndpoint=https:api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(#{version}\+.{7}, shell_output("#{bin}circleci version").strip)
    (testpath".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}circleci config pack #{testpath}.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(update.+This command is unavailable on your platform, shell_output("#{bin}circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}circleci update")
  end
end