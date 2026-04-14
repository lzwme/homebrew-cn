class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.2.5",
      revision: "a72d5162cc390d7b6eee05e2b6a8be909795c8a6"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c5e6125c2eb17638d7d138df64f32b7f49af52fcdeae831b842b6bd8e482582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c5e6125c2eb17638d7d138df64f32b7f49af52fcdeae831b842b6bd8e482582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c5e6125c2eb17638d7d138df64f32b7f49af52fcdeae831b842b6bd8e482582"
    sha256 cellar: :any_skip_relocation, sonoma:        "f42bfedc6a85e5e62fb40c4cb7ed3628fb8279ab129adff963900658d15aa5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2512f5d3795994b0013724723d15f6f51dfaa4ebd4fa390d8dc18125da01470c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e83906056856b6df9f5273872afde6cab0df28058439ff5c19ace43c475f9d"
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