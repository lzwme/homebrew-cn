class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.32111",
      revision: "5da94451bf13865af05e98c18275bf104792e133"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a974da0db81a32f31d4d448cb885041caee8dfe64947824f07b4c124fef03f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a974da0db81a32f31d4d448cb885041caee8dfe64947824f07b4c124fef03f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7a974da0db81a32f31d4d448cb885041caee8dfe64947824f07b4c124fef03f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c44aeee81f3da1a908c0dadd23cedb2286c70c7d457478ed968d91abdf4aef7"
    sha256 cellar: :any_skip_relocation, ventura:       "5c44aeee81f3da1a908c0dadd23cedb2286c70c7d457478ed968d91abdf4aef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f44242b9c040616731f63e4872b9c27d9aef5776e76a943e446b70c41af59161"
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