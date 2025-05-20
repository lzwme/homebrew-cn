class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.31879",
      revision: "df8a877121ca288c0222b942ff88612809e18fb3"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8dfc294b615e01ad89b7b9dcf09745f384106e6b40db984797773d065edb7d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8dfc294b615e01ad89b7b9dcf09745f384106e6b40db984797773d065edb7d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8dfc294b615e01ad89b7b9dcf09745f384106e6b40db984797773d065edb7d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ecde0593070f7586f9283875a728a5b181d1cf57d092fd30389f4bf43960aba"
    sha256 cellar: :any_skip_relocation, ventura:       "2ecde0593070f7586f9283875a728a5b181d1cf57d092fd30389f4bf43960aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05deda75106aa97375cdae9325f37129e9aa639d399f9cbfa1f3231b5d322e77"
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