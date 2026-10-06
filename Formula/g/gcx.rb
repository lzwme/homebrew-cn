class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://ghfast.top/https://github.com/grafana/gcx/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "ebdea26a970e6c7307472c886b3c4a2e74831ddf59726911aa01475f8f41a9ea"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d15292334d978502c52eced8eafac6360904bd1a7df637952304afc9a327d36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "088da65f0d7989c3932404a59cba320d77850b4356691985e3ea834a0def2ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "765335f38389328f3c7e0251828f0060ef4c849e4a1ef4cf8a763182b033be13"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fed753ab8b5318caaf75f9aed86cee024671a1757cb52ff9803f5fcd1dd3c14c"
    sha256 cellar: :any,                 x86_64_linux:      "33442674c04e28f1cbbb0d07b14fc0c8dba6cb602a0735fe7440099d3a4a9958"
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