class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.26.4",
      revision: "03c6c40c8f11d8d0057bf258bf573a05c1bab5f6"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf35095368275affdb47b1288d4c341d59f401032f1ca1f54d3bbffa0fa3788c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf35095368275affdb47b1288d4c341d59f401032f1ca1f54d3bbffa0fa3788c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf35095368275affdb47b1288d4c341d59f401032f1ca1f54d3bbffa0fa3788c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfe70ed4dd179dbb6976bc221b8f39670ff5085ac1873dd868aed6883b9e113b"
    sha256 cellar: :any,                 x86_64_linux:      "6b7db788038b15145253267e687eecd9db760da1c4ec6db14569b9e5916de61e"
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