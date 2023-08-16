class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.74.3",
    revision: "bdc6fee5e4c7c4f0fade19e61564888dd112674f"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5d9bf047c789d565640aa6403bf956ca01f1b23f28d0071941cb5e58da88abd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7434d02c08d43303281c770a19b184011b50436a2dd56821e275e2bb292526c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "883ec6214519efb3a73a40b043a85223b805702cc0b69a109b8ceeca7760016b"
    sha256 cellar: :any_skip_relocation, ventura:        "f7294fafeacfc071f2ab8089591ad5e5eb16f928687be038399fd4f0062bf590"
    sha256 cellar: :any_skip_relocation, monterey:       "37a9ee0f0d80adaa12a363e8a8f1c04680fae4f789532e728595ccbae6ea3914"
    sha256 cellar: :any_skip_relocation, big_sur:        "94df38a7147c22a5bef6e1b9dbb5cfc41d71c4f01f3c3200d9a523d1fb836d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9df540234a09417c36484576db0147ca4764dfa305afd674ad9e1e46dfc438ac"
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