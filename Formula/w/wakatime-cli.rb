class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.86.4",
    revision: "6c9f8912b2211562e066b941067f2280d828e8c4"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "786e3cbc374d9663a156b8615797153d59cb82f20e49dd538e824f78569d02a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45fc919fa40e9f1b3a3b87d68777e8f211ea77c5f734c5d7667d6608bb8a94da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "604324fdeb5a924dfd195a70c2b75c91b7028c791dc995e95380e554a97e38d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "916c4d92a108cdcac3f124ecac2f08538eedee2be85117031ab9660ada3b2217"
    sha256 cellar: :any_skip_relocation, ventura:        "b3999d1d90ddbbd3855c1354618a4f4af96f847bec03ed0651810132855918e5"
    sha256 cellar: :any_skip_relocation, monterey:       "44818f4de015a35600ad36eddac97d92cc7df9222cc9a88eee24b81668212f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1dec29ab85221455b91cd6d6826863fb048e3121e50e5d7d913fc996dc03080"
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