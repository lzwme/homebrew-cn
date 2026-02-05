class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.34283",
      revision: "28a3be85980feaf0f6acedff5240a75baac3df7b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ae6f9e62df30c32857a9dfc99f59b6eea8ba60019bf92f88e91586f7973e5ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d1683e619a29a134ae6ae88e1e3e8d857757e062d01545f1befedd0ea09a1e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726fec6dff81c39f10d4423ed05689fa925e067aab2b72d111b73fedc1413647"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1840affde8403785934e853d764808acf72d9479c3e6cbe3f307498e3686e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bab86c27e6d78c722b1da19d6b865aace44582ae2eac443c6748218ea3ebb15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5250e584c9a767935e1ab9cb1e4cc70160c879ce2bb59364ed3688a13fff3647"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=#{tap.user.downcase}
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end