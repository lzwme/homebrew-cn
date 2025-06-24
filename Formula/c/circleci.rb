class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https:circleci.comdocs2.0local-cli"
  # Updates should be pushed no more frequently than once per week.
  url "https:github.comCircleCI-Publiccircleci-cli.git",
      tag:      "v0.1.32580",
      revision: "eeffe5201d9385906ffb75292fd4d88646d2a5ac"
  license "MIT"
  head "https:github.comCircleCI-Publiccircleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd38bbbf993f239fe3e9bb0f7a76321ccb9f5f3b6e56a4a944bd32f3bae8e1f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b418795106560b1550996995e385f518d62f2dce129ce96703f22a59764a03e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dd314b7c7f530b629259fb6e4d87de4131b02fe6547e042bcc7efef7f520e78"
    sha256 cellar: :any_skip_relocation, sonoma:        "cda3c5ab6374d0f7d17a13e2b783fb1eb9780e9656cc177b783e8035630a6f3d"
    sha256 cellar: :any_skip_relocation, ventura:       "b441c72d09f751d2a67aa48201650e474441c91d21504f0ee2d7029507e534cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ed1116a17715c2637a8d50f469d3fd46b13e00962a9ed89d130eed506343fb"
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