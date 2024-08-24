class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.30995",
      revision: "77b1f5175a42e351a0104a22279fa72f1f1f9ea5"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c7c77d1e5648627c96cd3cfe8aad738074ea5f5c6c07e01469e5d3d56c53916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7c77d1e5648627c96cd3cfe8aad738074ea5f5c6c07e01469e5d3d56c53916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c7c77d1e5648627c96cd3cfe8aad738074ea5f5c6c07e01469e5d3d56c53916"
    sha256 cellar: :any_skip_relocation, sonoma:         "81eed0e31f4c1260d2270b6474522a6b5a83aa6ce0dc697997bff517c3fb8a33"
    sha256 cellar: :any_skip_relocation, ventura:        "81eed0e31f4c1260d2270b6474522a6b5a83aa6ce0dc697997bff517c3fb8a33"
    sha256 cellar: :any_skip_relocation, monterey:       "81eed0e31f4c1260d2270b6474522a6b5a83aa6ce0dc697997bff517c3fb8a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa851d9960c700716ff72091a125fdd68f5f65b911467a80bb7887a9263f3335"
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