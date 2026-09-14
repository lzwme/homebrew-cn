class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "9dd36ca00be13df2bff82ea1c83e1015617987b6dd4d275e7d03dbf1ecaa4796"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f734bfc405d8982df1f63b2812b664a31c033b02072dd5f2cb13bddd00914540"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05865775625b6610c1b5706adcced936ed9233e356bb23b3576d52dca22c832a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a2c25ab062ec56ab946b1f0012cef7a4b815b95654c384c69733f5629a8564c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba087bd1591074845ce376803b5680371419abe59494d52f68cbfd39acf4a61c"
    sha256 cellar: :any,                 x86_64_linux:      "7f9b4591342afed7dea43b96a9ed465fb73d21a7a45a9c4196297b786ff129a2"
  end

  depends_on "go" => :build

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