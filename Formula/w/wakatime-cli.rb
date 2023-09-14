class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.80.0",
    revision: "9bf7d3f878595b98168ab7786082cd404f1e3d48"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eca8a98d746c70d2f0b0d197354d72f71a4de6b652713fb10b8318abd159b385"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05705deec8e2a082c27e99734c063f8a77118e1f7f2de75f724938f2b864d1e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96ddccc740edb9748c93db1a58303e8539f43f37439d4cc9dcd983fc827a1f24"
    sha256 cellar: :any_skip_relocation, ventura:        "138d3d4983d2ca5ebdd311aba90a444ec41e58ee8310a5f47eab346f15494e27"
    sha256 cellar: :any_skip_relocation, monterey:       "89a86e62b7e3fff383e02f54ac07ee7fd2d89e37998a3e6844740b18c76f0f88"
    sha256 cellar: :any_skip_relocation, big_sur:        "f236c2dc60c135867c437bf50a07a4b88227af799b8d7c844ca4f350c14f6362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f8149d4f1f220cfb824ea22e045b5b817c3f80bab96c4da7777435c74a43767"
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