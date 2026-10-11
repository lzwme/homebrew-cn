class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "30657d78b13ab5e54987fbf6c863bf92819820e5798f1d109467da06c3261869"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25ad07ff00258cb20523ba8d6bb871dec0e0e3ca0c4f397f9229d5b52fe10f94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a821ced2a6049ab3f6230b839438b2277dcbefcf1f3e9f0b0f2624ec52709267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f34721e4320747547ae550c997f2601585d2c9a438980b9d86f48fb6e33cd8cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f89a6b0b2d2e58131162af72071f22ffdb39305db3220fd8fc1ccbfe98d031ea"
    sha256 cellar: :any,                 x86_64_linux:      "afa4cbe049b14e709aec918282edaa6a315524624dd869206f2942c7ca27a085"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/owenthereal/upterm/internal/version.Version=#{version}
      -X github.com/owenthereal/upterm/internal/version.Date=#{time.iso8601}
    ]

    %w[upterm uptermd].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags:), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upterm version")
    assert_match version.to_s, shell_output("#{bin}/uptermd version")

    output = shell_output("#{bin}/upterm config view")
    assert_match "# Upterm Configuration File", output
    assert_match "server: ssh://uptermd.upterm.dev:22", output
  end
end