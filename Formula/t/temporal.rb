class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghfast.top/https://github.com/temporalio/cli/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "14280dbc5f157373a2b34d7d333dd0c8f1b8506fa9ff5b332edc9048527af6f8"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e67abbbbcc9ffe3fe6857a5b4215adfdd368e82fa77bbbe1b3d62eb395c6228a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29ea945ee33d6305113e48604e328d0a7528618a4704d92817baf157df916577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ae10408774c8319d5a7e6a571da083afd5ed3c2521c8532162febe87a11cb6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "713b6bd559c89e0b2950399d7c2c0ec29f063e6ffec1c7b7a1c1c4af7490db52"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "870fb1f806477746de9ef77b4e0db55d78a6575280204b63c2fe9b0d1301ea92"
    sha256 cellar: :any,                 x86_64_linux:      "9e9bb58ca66c323bff062b813b4c0cf6b278555693addb95d833b4d8518c421f"
  end

  depends_on "go" => :build

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"

    generate_completions_from_executable(bin/"temporal", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var/"log/temporal.log"
    log_path var/"log/temporal.log"
    working_dir var
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end