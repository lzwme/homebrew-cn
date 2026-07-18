class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://ghfast.top/https://github.com/grafana/gcx/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "a1311e1e820e076bf5a9eb78b1d1336dae193be4f88c3bce11de376cff8e6174"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6a4ea68759f8a706375a758856217ec6efa499e88d30efa002eb21323f80500"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fad35f4f28c1fae5b656e4153f7a46de0f2c7446937d8cb4667e3d559935b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f87a39e77b53ac02bdb20c92c116855c2a888ad3b9c3fe8b1487e86122c7abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ac063e90a451044d902ae493f6fd5acb1a2190a9027af73c6ba3b7a5fd38af1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0122710ecff21489d0e07f07deaa16de4c0c149a4cfa8ad492b17e281877fc93"
    sha256 cellar: :any,                 x86_64_linux:  "bfc63f51be2eeb1d5d8877de28fba3a73ef26424e28a3e7c6077fddad385edfc"
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

    system bin/"gcx", "config", "set", "grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "Unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end