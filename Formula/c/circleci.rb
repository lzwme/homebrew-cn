class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.31687",
      revision: "83b96d30cb8e66c3c57539b7cbaf4ae6fe6d6760"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c3b5fe4cfa643bd67cde6f535e24dec8a10cf99ead1498e783b7a538090e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c3b5fe4cfa643bd67cde6f535e24dec8a10cf99ead1498e783b7a538090e7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32c3b5fe4cfa643bd67cde6f535e24dec8a10cf99ead1498e783b7a538090e7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "30972352c3cb9a8e65d5e92be5b001216ba18d800c19cf6a8bae94419c7379aa"
    sha256 cellar: :any_skip_relocation, ventura:       "30972352c3cb9a8e65d5e92be5b001216ba18d800c19cf6a8bae94419c7379aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f1416f2b5e761d20fa5792ed5c8d91dfbd536ab81d939153fa6490e46e3422f"
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