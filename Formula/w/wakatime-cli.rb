class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.124.1",
      revision: "4780247957149c4ef3fb0860f85b8f6d899b313f"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e987128c1d482672baa93f6fe40ad02ea7615e1f31c17f67c9ca5779e3082f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0e987128c1d482672baa93f6fe40ad02ea7615e1f31c17f67c9ca5779e3082f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0e987128c1d482672baa93f6fe40ad02ea7615e1f31c17f67c9ca5779e3082f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e18ffef7b035b6eba4d89d489765ef3516cb3e4ea83a944a0a6ba7a8aed7df1"
    sha256 cellar: :any_skip_relocation, ventura:       "9e18ffef7b035b6eba4d89d489765ef3516cb3e4ea83a944a0a6ba7a8aed7df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615879f2f5eb86cdc37cea8c8bf4b440dc613e15167e9e54a2bf9ac1baa79a10"
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
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end