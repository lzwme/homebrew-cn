class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.29936",
      revision: "c2d98ee5341feda1e3914adf443f5559c8459719"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d485f94b89423957ae11d2af600ab0c16562e9c83e2c90da965d23a3dc04dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5e105bdfc8f4842d41cf87155200ed114c101800af113b8d3099056e477c7b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4d43550ea15d593e5d0559116d8a815e305b65f7e68d8dfa14df207e0353c33"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce1f71cf34c2df2caa821177d1429fb8c37056ed0d14b269ede5e755b93b1139"
    sha256 cellar: :any_skip_relocation, ventura:        "c299c51cf37a26a1d0ba14f058cd7eae28380a1938fc727a9f66e5848c651348"
    sha256 cellar: :any_skip_relocation, monterey:       "6d699d91183c43f15a5fbfd3ed5373cc31e0b4580014252d18eeafeff60596f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca7db746b5853d9d548d104812b9ae56b09cc0cf9997848732f446b9be72ff5a"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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