class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.15.1",
      revision: "6c78e06351df4981a3512a892bff0749973ab8b4"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c43e26c1704cf5380257c8a5ae05a1420d46cdebd9aa6df258b25c14c9bd68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c43e26c1704cf5380257c8a5ae05a1420d46cdebd9aa6df258b25c14c9bd68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c43e26c1704cf5380257c8a5ae05a1420d46cdebd9aa6df258b25c14c9bd68"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfabc9e422112f5ad6c2dccad5dac11a768961dba911cb3e6f9b453e6870350e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd77732e9940bb357ad53c1dd57251f3c2beaa30e1c032f553516a8d51711bd"
    sha256 cellar: :any,                 x86_64_linux:  "4bb442daaf9b4ebe124b8dcd4df808d5783d5bdce7314335628a879e6de0a6fb"
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