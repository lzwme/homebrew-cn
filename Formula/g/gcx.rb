class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://ghfast.top/https://github.com/grafana/gcx/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "52e4b90a3f02cb524cdfa042b000a5c5e3b28c9caa7b6e196d365c435aea3f1a"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf50c4962f03f3e9541535f87d068157b37b6b8abec33e64ca6dc96ffe7558e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75d5845a0537ea33196159c267e06d80ee0c22d07d1ca358574035eb041dc8a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ba4dc6edf1557f608ce3401262e8dbec13133293b48d49a6c4b85632e17281"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca4fa92adc916a6787bf78808b58ce2aa0809ae755d2627973e27cd847856c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7c55e78fbc3c821b3483c8c0512d8922f13e372a30503dbfb3bbf6302dd503f"
    sha256 cellar: :any,                 x86_64_linux:  "e77d8acd097e36f14f3eb60e0cf8a05376aeaf727c5ac8ccb7f4c7eddcc4ff7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.commit=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "stacks.test.grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "Unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end