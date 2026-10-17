class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.27.8",
      revision: "1af8533ebbfa509302fdd48a48b9e412b2930690"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "312a2cab01bea6211574a25ef69c54c49b2a8d1cb35ce51d12d457363ba49dbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "312a2cab01bea6211574a25ef69c54c49b2a8d1cb35ce51d12d457363ba49dbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "312a2cab01bea6211574a25ef69c54c49b2a8d1cb35ce51d12d457363ba49dbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40432d25dd5a860c4769a466af00c651aead7cc1c7aca497616a91940d98cb9d"
    sha256 cellar: :any,                 x86_64_linux:      "ccedf6e01aa83ec1acec3a6ae7af3fa0476566dc2c8a827bdb18a28c152813d8"
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