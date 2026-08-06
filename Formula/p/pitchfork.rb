class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "f6a36097a7f288d428988fdd3664154e1ad847b7a4fdb60065e44587f1b2179e"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d8e3f2d3369d38452997008376b23342244ac1a387d0ffc05c7453e0452e994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b89994e55e8bd6955f36523bd7b85cb4b828b612013295cf2e456e77834c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db796c6d18484443da5fc112115d0618a0e023ac7555a49428104caa351aa474"
    sha256 cellar: :any_skip_relocation, sonoma:        "71ed98c737059e0c1e85c5992d3210b404fe20f306a93858ef764152ad2968cf"
    sha256 cellar: :any,                 arm64_linux:   "29069c11f5bebdeed3507cf6efc16887c68ee658f97bb51b1529b6d1cec686d5"
    sha256 cellar: :any,                 x86_64_linux:  "ecfa00309e931df08cbd7d46ae6a989a40c53e5087052eb70b4d8326c5673890"
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