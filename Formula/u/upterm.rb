class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "060af94b43e0337b7da20b2560bc61ff91d0bc8112c0d273ac8d16391f9716c4"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32d05e90a046c43db1c49de60e1a6d90a338e8299f0c678b1c85f98a3bb05117"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4bcd1293177b86759b0ba036542a12b6a305d53b69fe734dd2baedbcbd9e1030"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bab4d23dfe8ee73227b3eeac1cb4d345e81447707037a2f28ccc2b8a16594ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3d91e28dd8d2884e2a5179f8d443f04b1a82d2f519f2151b8f1c721f750f5f6d"
    sha256 cellar: :any,                 x86_64_linux:      "10a0160207a81c29e04aa1b99644043e572f4819671f29e83122b58a62e4ad2c"
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