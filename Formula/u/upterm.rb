class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "0c9cff5d45d2781f5bc95fb783befb92e75a017b70a221a6bc6853f738e99b01"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d71d6feefbfed4c9dcd8e5c86c96b3b16f787236eca44bbb0454efad033f632c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38595f1a3b4b786da34ef1601db8a10e78e1bc38d3ec2033a4acc880e6fb5388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23e8105c270991767f63fd60772344dab55d85ad8c5058a4ea7f2057ab9c8775"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "939503212980d1287cc7d7a76e080da1e8ac064f1ca37d05bc5db3fc4b2e33f2"
    sha256 cellar: :any,                 x86_64_linux:      "d363f59d212162a42827862eebf2233bcbd8de030a03bcec0c3096c821baf8da"
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