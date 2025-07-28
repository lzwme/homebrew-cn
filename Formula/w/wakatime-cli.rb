class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.125.1",
      revision: "14be592ce5bcb15be9067a5f15a529390d8fe68e"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc55d4b9687038cfc53a1b1e64fdbcc9207a19427d1e10bb13e57cbbf6fc76b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc55d4b9687038cfc53a1b1e64fdbcc9207a19427d1e10bb13e57cbbf6fc76b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bc55d4b9687038cfc53a1b1e64fdbcc9207a19427d1e10bb13e57cbbf6fc76b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f191e5d23b65e36c7d39dc1cb5a7e825b9a4ffeb0c1fb8ee94a0748b230c1d6"
    sha256 cellar: :any_skip_relocation, ventura:       "0f191e5d23b65e36c7d39dc1cb5a7e825b9a4ffeb0c1fb8ee94a0748b230c1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e6c5e51af570b8e22c9546b9059c23ccc33bffbded3dc192543cdf3eb028b6"
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