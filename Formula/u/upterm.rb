class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "818b7bc53adb51578f81b16ff293034232f66d51f07feb7a1371b2c4d0a923e1"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a33efbe45bbbf3cbaf0c4d6a97aa58ae19bc3404e61262b8ffb12bfe4ff1337c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d911fad7ae93e3ac08487d8f6f72ba4aeca87cf4b33f84efefa951f480a602fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b19b56c94eb4d4b7b79a71dc67e2bbf02da64e0a13488843d7e9ee143a9d6ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09b3fc33dd94f7e5b0074774dcbf57ffe8927014a68bfbee2d9009fd0fd6d573"
    sha256 cellar: :any,                 x86_64_linux:      "ae83d687e995a58e42342c224cf69cb8d8934920f062f3a2ddcfe3f8c5787c22"
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