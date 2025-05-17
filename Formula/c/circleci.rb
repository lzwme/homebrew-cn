class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.31792",
      revision: "3c8e99703d23e731f59c6c1bd2f1bf174a7533ea"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56d1a2ea4fb264088a663584e286cf93133d2a78cbbd23c37806f94737fe1903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56d1a2ea4fb264088a663584e286cf93133d2a78cbbd23c37806f94737fe1903"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56d1a2ea4fb264088a663584e286cf93133d2a78cbbd23c37806f94737fe1903"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2484ca875456d85254d9ae012333dc6f748826c5f3ec5c176b178a7e5514728"
    sha256 cellar: :any_skip_relocation, ventura:       "a2484ca875456d85254d9ae012333dc6f748826c5f3ec5c176b178a7e5514728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61e94c4e473c477d0de52f834a52d1a54c001759b36b3eaf7babcc590bd3c1f"
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