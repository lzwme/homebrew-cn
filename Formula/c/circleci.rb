class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.32323",
      revision: "1871b5b19b82f1bcf629293c2d57424a7e97a1ff"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aea471054ac1203b37039101977488aa6275a28c9a1ba968ad40c48381b5ab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aea471054ac1203b37039101977488aa6275a28c9a1ba968ad40c48381b5ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aea471054ac1203b37039101977488aa6275a28c9a1ba968ad40c48381b5ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "adbfe55b8fe104e1e5e81448184fed98e9de2465ee85f155125b9460b6fa5906"
    sha256 cellar: :any_skip_relocation, ventura:       "adbfe55b8fe104e1e5e81448184fed98e9de2465ee85f155125b9460b6fa5906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b03a55e2359fc0c973788af50625541ddb935af6ef85970ce4d6ef09db371a7a"
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