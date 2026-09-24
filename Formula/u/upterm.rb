class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "c9a3217a1bb164ed1f20286df4071fbf04893f2c4c55d6a1e9bee28e2a5290e6"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71e261316ad068abdcdefdf56ce333beb5bdeb5b9ba63bf3129e448353cb1690"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ea78c1d2fa691cde59c5086504b2352d660d3ba9c5193ef12b4be8138bd535b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c914867dfae134ff3bdfff093baebdf103e8418c810abda9209431210c91e27a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce26a31ea3b86513039410dba84f4032842968ef15ff9ecf06c5f2eabdc0dc15"
    sha256 cellar: :any,                 x86_64_linux:      "fe46dbc1c3ec551ed0c5b511c5f03bccdd86ed1d6f861977756d7731475e2040"
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