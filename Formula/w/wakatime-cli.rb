class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.3.1",
      revision: "89c9d2830410402db34f26dc2d58f8a33f8be270"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d95dc88793a65ee8f5f10deb1d7bd80d6bf124539949129423a80d2e372c17c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95dc88793a65ee8f5f10deb1d7bd80d6bf124539949129423a80d2e372c17c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d95dc88793a65ee8f5f10deb1d7bd80d6bf124539949129423a80d2e372c17c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cecc11f9d92bf6ea840a6a1a425020f369070bc6d4414b151d5cca1796856c1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76becfce8987ac59c19ae22f20a42b640cb86146446311071296387a25ba4d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ac27c2a682f0925e27cb8025cee3d36dfc7d045e4a1cb691c87983fd49a9c4"
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