class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "896f2185f02cbf9821002a7eea864572f25cbcc52358975bcfee137418c1343a"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1cafa8efc081744cd93253aca9ee57634d9b36912684111f2fb486c35f50b08"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7983f94593826048fb1885541cea8c3701042945e1f56d0e6b702adde5da0430"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "674f1d74af63c4fb161e96661daa1bffadbcf324a10a5a2f2d13376e5506cb80"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ebee77a4f36eda298de37f70ead0e664e6f71d0c1a1b21698b13dcabe48ef8a2"
    sha256 cellar: :any,                 x86_64_linux:      "9af8a65f99798c0225f1f55266e09075b322dd105f4e91462a81a725ecd3b569"
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