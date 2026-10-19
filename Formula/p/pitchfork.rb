class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "477f4bafbd7c09c4e65249f834248c232eaaf88b727df86697e0ce8c0971a9a1"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98a224826c085783dff6de7d7727d7f029cc9dbb151cb28630a0ee693b60b4a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54204c596674a5f7385deccd16036c5fa275da5ef1c6167107322877b6e32687"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0a27b10bd4cd9dfbbb0a1a47645051a0766b71e844210ab400d4f9b52c6ac29"
    sha256 cellar: :any,                 arm64_linux:       "e695ade8a5bd277e7164cf639451759fb344aafc315b06e46cd705b5606c87f5"
    sha256 cellar: :any,                 x86_64_linux:      "95c52eb6e748d97868ca8a685d35314d32140e4be04a29ef2033c2d9f7961bfa"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "usage"

  allow_network_access! :test

  def fetch
    cd "ui" do
      system "pnpm", "fetch"
    end
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    cd "ui" do
      system "pnpm", "--offline", "install", "--frozen-lockfile"
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