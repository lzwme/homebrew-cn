class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.26.11",
      revision: "20da082e5681dc5fd7b174396a7237bac5f5555e"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d4bf00a7e90e6d199b1000ee5e52389f5cb9ade32ef16758450c868a154fd62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d4bf00a7e90e6d199b1000ee5e52389f5cb9ade32ef16758450c868a154fd62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d4bf00a7e90e6d199b1000ee5e52389f5cb9ade32ef16758450c868a154fd62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98574719713d435156c66117ad45c9c94fa32ec44354a349f7607120d1ba44cd"
    sha256 cellar: :any,                 x86_64_linux:      "dfbd764772852229b213feaecd1cec1d57c9314b552729e78cbc78b19e4fb155"
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