class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.26.7",
      revision: "9acca448dead5a6ad1876052e940000ce0ed39be"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f654a4688497f67b55f89951ccb7fbbe463160280c14e60b5bd9eccf37b88280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f654a4688497f67b55f89951ccb7fbbe463160280c14e60b5bd9eccf37b88280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f654a4688497f67b55f89951ccb7fbbe463160280c14e60b5bd9eccf37b88280"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63466fa594599e6f6792ba4aed2d5da1be9480bc946923c4299a95a04a7a7344"
    sha256 cellar: :any,                 x86_64_linux:      "aa80de66088fe8b87780f7565a8a5b0c8a74d56f6fe735aaedc56edc677aa266"
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