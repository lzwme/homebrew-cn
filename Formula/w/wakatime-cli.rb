class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.26.13",
      revision: "0cc4374bd9206c4ea489bce2783ea9113d13acfe"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1000cc678d63d9bed3682ae0756e328cf11f17fa1c6e5c84c926791d20d374d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1000cc678d63d9bed3682ae0756e328cf11f17fa1c6e5c84c926791d20d374d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1000cc678d63d9bed3682ae0756e328cf11f17fa1c6e5c84c926791d20d374d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39a367252008014c15d10cc9a33d0de979f831c514d2505c079c0b5f3c9beb66"
    sha256 cellar: :any,                 x86_64_linux:      "7b7304836e796d06ac1f4aed85d2c4ee705695022bdc3a4768114a0870c33b15"
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