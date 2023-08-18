class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.75.1",
    revision: "5bb04b944cb275d312d609dc423347acd2885d04"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8587119e55ad00214109d986432df0abb877751bd6b144aa3a35d1cd1f3d1e24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "916be90541db6a01d94baed09d6db8eb004f5f5a28f612f57b14333f1a6920b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc6086d351589f01249811e79fe60094d2ae0a15e6af7ac4878339500af42937"
    sha256 cellar: :any_skip_relocation, ventura:        "b86273f9254ab447160d98e2ac9822174aee6e093f6c7688995299014043f267"
    sha256 cellar: :any_skip_relocation, monterey:       "8e14e030f730eeb2ad236f1676b0eb8a7b13d96a8d5440fb5920d439d9ea24e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bea38e819f15993ce6da70473e3ae14dd9dbdf3dbbba64ea8ded2d0e99ac4427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6706a600e9b7d8e27f646d71155c56ef0c69e56684128d65ec3c4cbdffe1d70"
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