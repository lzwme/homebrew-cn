class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://ghfast.top/https://github.com/grafana/gcx/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "27c694a8377d6c9bbe59ea15660194991e603709672b3b1d3532c7d5b2cdfaa4"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a2da896a87c2ff6db722e83755f0cbdf9adebf872ce7371baa3db9439b6aa0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "81d63247a17245ca042f70aaa3fc2219de3279516748dc47adfa8567d601d6bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d53fc0863abb29863b7eb3fc3ba1b486b58027cf9d81505204b51ece0730f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "635f0c65fb3bc8901b8340e27bd75a4d5aff6152daaab89338c50537c75d7df3"
    sha256 cellar: :any,                 x86_64_linux:      "d247ac718fd3037710d6d9b808707fe1f9687fda090945bbad48f768a5fcb97f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "stacks.test.grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "Unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end