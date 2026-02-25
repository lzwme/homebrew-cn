class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.34616",
      revision: "60096dbf2fb0de4468431bbe761b8156e1873c9b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb4897ccce79d36c9906cd9a7fe29feba2c30a33d478363caa1063dd75aa56fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd248e87a6a38bdb63f741bd3027abf3f90baa921a8d25bc08e51a1d0638b469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d5a71055a24ba539c7b0eb1b33e5ce678e84795e32702e11bed4498ccb55c96"
    sha256 cellar: :any_skip_relocation, sonoma:        "6de4b8307846884e14e9b3ce7292f69ef8b9752e78d0411a9c60396698559f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b91823f0594c45b656e56e3c6e89ad0dabf341308ce1ee36d27b354d8a48f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53b3cd65078da71ef77ce596659aafdf2339b1218f136cd64776b28496656f6"
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