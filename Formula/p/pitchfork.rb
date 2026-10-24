class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.32.2.tar.gz"
  sha256 "59940350a2af0076dcb4de7e60d92c3c86a81c26d4d44d33761181bfac3fc094"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cedac91f71aedd82d78c69789ee11f9a7afd5b125dc3d5e35e2063b40a91f8ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c347be4c07c337ba703c21cb7deed0d26f3b33c8d1617621fbde7b7403e8d7e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfd08dd9c51e4cde80bf75fff46a85f0da55ef4e5b64eff7ac1c4ac142545135"
    sha256 cellar: :any,                 arm64_linux:       "311aef2c06c6328b5fea8c5c1115344a143ad623daa8a8d33c47564c010ae25f"
    sha256 cellar: :any,                 x86_64_linux:      "459c6e751795e6678e10b92b88e1b4ce9ce3be3da97bb67ea0db4754436fecac"
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