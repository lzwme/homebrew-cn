class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.27.1",
      revision: "6d0e6fd53d574fabd7396633bc8f3a5262d081a1"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eeaabd3703e0115f1b83cd3b3f91b183fa75a7a9055fe6907873f5a483f1e4d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eeaabd3703e0115f1b83cd3b3f91b183fa75a7a9055fe6907873f5a483f1e4d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eeaabd3703e0115f1b83cd3b3f91b183fa75a7a9055fe6907873f5a483f1e4d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7114a4c98f578d95fc45ca586a311462bd8003a8abaecbb34e8b1caf3de3b918"
    sha256 cellar: :any,                 x86_64_linux:      "a904956d19069676bcc6e9fe737e1db694d4d7e260a9df663104670a02c80326"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end