class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "c3351486ed6cf1be3acd8dc787c95693ab6da3f8414b275e26af404ff7e1aa0b"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c3fc45710ba07f896d8d59ce93c0b3d01e6f789c46479a5ef833548a124033a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de273dd25492d007b9dac0fdca6331d714e4f558afa0200184c1f21064d8a46f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da456d3ecee23aeb993b5830163290a6fc5cdcbe8965819884cf78554538c6fd"
    sha256 cellar: :any,                 arm64_linux:       "1dfd8f06272a427c1cbda300825d02457018cf6628247dd11193d1988cb32278"
    sha256 cellar: :any,                 x86_64_linux:      "517bca18ad8f1f1998b96a916b89e3e1cfe967dd1f317d0827fd3cf49abb4e66"
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