class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.31983",
      revision: "56e186de13c34ea8aa2a917a5dfac26008a0a70c"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e02272bedf6ac18ce7a64c7f5e464be5c17c95282ab28409d2c358f38a754e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e02272bedf6ac18ce7a64c7f5e464be5c17c95282ab28409d2c358f38a754e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35e02272bedf6ac18ce7a64c7f5e464be5c17c95282ab28409d2c358f38a754e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e524f9783fbe067dea4cef965bd1f1212862a3dca8175844f67d7e266fefaf3"
    sha256 cellar: :any_skip_relocation, ventura:       "9e524f9783fbe067dea4cef965bd1f1212862a3dca8175844f67d7e266fefaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4e1004394072112ee3cc20f657a383fbd91f64e655cdccf9d091c581279c40"
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