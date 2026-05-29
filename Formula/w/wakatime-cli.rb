class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.14.12",
      revision: "07ad800607c25a0b593308be1279067851f51f47"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c956e5ad534223b0c15491c54d1d12f9de43f87890ed93455fa06024421d8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03c956e5ad534223b0c15491c54d1d12f9de43f87890ed93455fa06024421d8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03c956e5ad534223b0c15491c54d1d12f9de43f87890ed93455fa06024421d8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee9c2e9bbd86126e4065175070c0c29e312cb39caeab64237e4e950621cbea2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238555008b2ded48aa84b4e17e7a7dc0e8d0f931bc031068654c9072706e2091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aff94b6daaeaa9e91a60de9db7d5b0872c8cb60f40ebe781354f174f5316669"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end