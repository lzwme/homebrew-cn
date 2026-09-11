class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "2eee37b11631e7ecf2a51c94d7a5051fcdf5beebf0fd69f50c9272fb0252de55"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a098adc09cdac17542091de620e62488bd3c1ecb2fb18c95d59acf903cad0b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b62c6e7245a0752d201607568101a2739114a130d26fc0ce1d20c332ff9d958a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3986346a3ec785ab646a9fc2aacc7753e324268977b357b1e8e6aa67088b79ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9947b98929ab9625fec51f135dada2e7600ffeed812ce067a42c02d9ab6eee2b"
    sha256 cellar: :any,                 x86_64_linux:      "aa18a1d6e0cc21fc7d2fde94fe82e5795f24604cfe86aa693ebf3622e6a2f881"
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