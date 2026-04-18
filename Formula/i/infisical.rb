class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.76.tar.gz"
  sha256 "ebf9615b99ed32befe59c8677339eb26779000868b1606eb5fcf0f9fd3ecea52"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14f1dcbdacb5db12e9558b5af9891226adbcb5d74ab87ddd539b1868815f1b6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14f1dcbdacb5db12e9558b5af9891226adbcb5d74ab87ddd539b1868815f1b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14f1dcbdacb5db12e9558b5af9891226adbcb5d74ab87ddd539b1868815f1b6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "041e46ff076694b56f88ac0db6da5c3eef6b8c947d01cc78eae4d3df96361361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4115d7f5b22507cfb630209a98b237acd2800e613e41085d44e2973b5fd1459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f306bf641eb2725a6518603b0e86fb25cb1f9e66e82aaadf5640181935f363fe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end