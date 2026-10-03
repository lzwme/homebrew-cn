class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://ghfast.top/https://github.com/grafana/gcx/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "6fee15c6d0b241fa9128e01e5a5d3ce273ddfe1a7e3bea90d06427e3fba0aac1"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b49f4a7248052c873ed29f8058fbc8e972e86558926b9d1ae4c98be5c93747d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e7ac088fd65b920cbfc233ac40e4d9b5d6f826d20168850b440d04ebe480d6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a595bb9e589231ceed604e0c128d0ff8682cf0c0b3ec5996525dba4912c3d9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "466bd976dd86bc0c262e82caa206224b9f73bbc7a0f30c6dcbadbceae60da776"
    sha256 cellar: :any,                 x86_64_linux:      "4d5a10f8434b64bcfeded12f2241eb200046e91acd3dfbd0257d780636fdaf61"
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