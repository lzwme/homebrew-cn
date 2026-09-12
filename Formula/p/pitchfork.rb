class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "88035f4929a5df10515a27f6eb1d77f7c7eadec66720d84cfe1866f475a25cce"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e7fef3c912c572d841146420f743b517097dc9e9ea4f3b6236ab48e4d3cfcc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c3be9238feeb1a0b5f52674044200747d937ae3eeb89a6c40b4044214b7e589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1103e9b04790cfac2e588e2381afe83e9a4e4646b14951626e43ecc79dfe2709"
    sha256 cellar: :any,                 arm64_linux:       "de7495b326bd281cd9bd6427a049c711ca7545561c5018f883f8704525935493"
    sha256 cellar: :any,                 x86_64_linux:      "02772d8ce52bbb2ddc3ac4b17f8b75399cefc212750ad5657ad81ebcfd727283"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "usage"

  def install
    cd "ui" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "build"
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config

    port = free_port
    pid = spawn bin/"pitchfork", "supervisor", "run", "--web-port", port.to_s
    sleep 1
    assert_match "<title>Pitchfork</title>", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
  end
end