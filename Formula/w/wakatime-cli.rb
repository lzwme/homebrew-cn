class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.26.14",
      revision: "0fa40ba531ac9bdb1c2ede22c9a441098a6df4c9"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67f0abb4d5b02ffb32aef583175e458053154c4509cfcf5f6706920a8e159a5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67f0abb4d5b02ffb32aef583175e458053154c4509cfcf5f6706920a8e159a5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67f0abb4d5b02ffb32aef583175e458053154c4509cfcf5f6706920a8e159a5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9bdbe9ad3cc68f22a390a99a0d04fcf22a5142e96c3690a19f7794664dae9c06"
    sha256 cellar: :any,                 x86_64_linux:      "b39ce8093c99c7f1a8d26f423c652d7eb2744a8240980567174a73064eaa1b0d"
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