class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "fb9f6bc5d113a13e13bbdda9986ba62226ed94763fb06225ef86f219ed79fa73"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4db8a1924024d3312aa8e94bbba02bb23fbf90afca432c225470bd4432f3f47a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4db8a1924024d3312aa8e94bbba02bb23fbf90afca432c225470bd4432f3f47a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4db8a1924024d3312aa8e94bbba02bb23fbf90afca432c225470bd4432f3f47a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53e5d111d9ee52b1ab4837ed9d762e18564bcb1ec242792011505c759a1113dd"
    sha256 cellar: :any,                 x86_64_linux:      "58a30024e3a332e0c4c8590af2c592304dc6733e756db10a308698adab7e4f7b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end