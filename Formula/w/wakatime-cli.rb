class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.27.5",
      revision: "0b6f5ff8bad52a23c60eecb95cb9e7868e297353"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "123c6a4864f9a82d057a6850a5e66c49f2f2c7699dae07312eeb43fef01f6e4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "123c6a4864f9a82d057a6850a5e66c49f2f2c7699dae07312eeb43fef01f6e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "123c6a4864f9a82d057a6850a5e66c49f2f2c7699dae07312eeb43fef01f6e4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c988490a3003697eedbc613477d69b92ee1a88a10baa0c744c92f799071dbe43"
    sha256 cellar: :any,                 x86_64_linux:      "6dbfe0584b686b43b7f7dd759973c1bd6ef089286a3e55df0ed3f2c3740da810"
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