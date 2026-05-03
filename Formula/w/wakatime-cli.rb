class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.11.2",
      revision: "7bc1e9882a695eacc29da69af5160d12bb237fa7"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d146c2069732351e8df79468609f528400114b8d59a543398acd2fef564a0570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d146c2069732351e8df79468609f528400114b8d59a543398acd2fef564a0570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d146c2069732351e8df79468609f528400114b8d59a543398acd2fef564a0570"
    sha256 cellar: :any_skip_relocation, sonoma:        "df326275ae8a0874118bae354a9a0a6e749279250304d9ee81edc715b53c8b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f8d61b736033c10ae2cea5a9e31ab8dfc5b344b48c8add3d3a360458de5f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ad160bedbcf29e6a09383f94add8e6a2b1cec867e58f9adb8832aecad3dcc8"
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