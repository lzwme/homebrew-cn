class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.27.4",
      revision: "8e2a679832203b2913d664372ba57223b2ca4d6d"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ce5c2a61166fb4ad405c58b261ef306b35f40eb419338d7d95a3f7a26d49fcf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ce5c2a61166fb4ad405c58b261ef306b35f40eb419338d7d95a3f7a26d49fcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ce5c2a61166fb4ad405c58b261ef306b35f40eb419338d7d95a3f7a26d49fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "15168a4eca950e3ac643c48b302f9ca2e9d41000c1794593f7cfe528746647c3"
    sha256 cellar: :any,                 x86_64_linux:      "418832a31ea14ba07492a50769065a800415e33f0ba5c4edf89bfa68e904ac48"
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