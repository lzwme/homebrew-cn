class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.30948",
      revision: "43103be4c6b7ce3782e9b9b381cb5c25c28608da"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a34641c88e4d0568f5ca9e8165ba7a328291261470093d20da6832d2d42aa8e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a34641c88e4d0568f5ca9e8165ba7a328291261470093d20da6832d2d42aa8e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a34641c88e4d0568f5ca9e8165ba7a328291261470093d20da6832d2d42aa8e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "83ba73f357683827e9ba63eca7cabc715b2b104d1ffd4bf91c16ad711ac9dacc"
    sha256 cellar: :any_skip_relocation, ventura:        "83ba73f357683827e9ba63eca7cabc715b2b104d1ffd4bf91c16ad711ac9dacc"
    sha256 cellar: :any_skip_relocation, monterey:       "83ba73f357683827e9ba63eca7cabc715b2b104d1ffd4bf91c16ad711ac9dacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ac93546e3c707c8e302c4ca9d93bdb1454254c45fef1e8088cc2987d5741a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comCircleCI-Publiccircleci-cliversion.packageManager=homebrew
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