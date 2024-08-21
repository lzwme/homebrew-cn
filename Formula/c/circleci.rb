class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.30888",
      revision: "5b9241be64aacef6d48114312069b3f841f23b82"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dd814f84ac2c10f392e5e37658bab43a17d430c78370e7074c02da05c158f0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dd814f84ac2c10f392e5e37658bab43a17d430c78370e7074c02da05c158f0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dd814f84ac2c10f392e5e37658bab43a17d430c78370e7074c02da05c158f0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "41fc0e1ab1c1d60002f16debc75f961681781faa24371841258f627f1a41fb87"
    sha256 cellar: :any_skip_relocation, ventura:        "41fc0e1ab1c1d60002f16debc75f961681781faa24371841258f627f1a41fb87"
    sha256 cellar: :any_skip_relocation, monterey:       "41fc0e1ab1c1d60002f16debc75f961681781faa24371841258f627f1a41fb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4602d479db9becfaf46a392a6809998c7bb2b58d919270aceade8aece1bad6"
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