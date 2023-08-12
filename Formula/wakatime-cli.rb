class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.73.4",
    revision: "3f10a7d868a647b8d0bd9717373745dee4a380d9"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15e18f0b33749185e5e4693c9d3be1ba5b63134ce7682ede390df89bcb81c6dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e18f0b33749185e5e4693c9d3be1ba5b63134ce7682ede390df89bcb81c6dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15e18f0b33749185e5e4693c9d3be1ba5b63134ce7682ede390df89bcb81c6dd"
    sha256 cellar: :any_skip_relocation, ventura:        "f64e0a3a3163e79c8dee61b194274d88955991e10fce4d15568118ec7ff5b292"
    sha256 cellar: :any_skip_relocation, monterey:       "f64e0a3a3163e79c8dee61b194274d88955991e10fce4d15568118ec7ff5b292"
    sha256 cellar: :any_skip_relocation, big_sur:        "f64e0a3a3163e79c8dee61b194274d88955991e10fce4d15568118ec7ff5b292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28fc9644d0d5efb07f8141d1d41b729ba9e248837ae779cc4028f2f949c464ff"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end