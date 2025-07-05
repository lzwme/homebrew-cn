class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.115.6",
      revision: "c6b2e313b68923c849c13f1b899d1ad4222e6b12"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba23f5b751bd604eb468f970a5afca5950faa1a5f9bcc1db7611b3206c4ddbcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba23f5b751bd604eb468f970a5afca5950faa1a5f9bcc1db7611b3206c4ddbcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba23f5b751bd604eb468f970a5afca5950faa1a5f9bcc1db7611b3206c4ddbcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1d95efa6af9e15f269ef1a130ac78316892e8e1501c8fe2aeb81a38349da534"
    sha256 cellar: :any_skip_relocation, ventura:       "e1d95efa6af9e15f269ef1a130ac78316892e8e1501c8fe2aeb81a38349da534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86626662106797fdb9a30ac5c96da0b1f1c45cd6c49c795177f765508eee6a82"
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