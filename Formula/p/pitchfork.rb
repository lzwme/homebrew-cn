class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "bdbb8e8e6a3c87603b4ae1e81353ca9c173f6f34cddafacc5f4cac46e779cb1a"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a80525d1b62b1b414a899dc3f443a0bf34fcb483409e8e458e75a0d928247c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b54fb867cd4319a02b9ae0b3be07530ffff3028e640921fdf6f0739336c567b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb447ddda71dbf128eb205f602f0c53e8ac7c0ed92819c50661b56e28ff2ee82"
    sha256 cellar: :any,                 arm64_linux:   "f9c79fb6c927b891c68d1f6a313ee8d4992c740ad27901e1fa6015ae1452e91d"
    sha256 cellar: :any,                 x86_64_linux:  "b33dbc1c3d0c2119d53aa0bf7b66b33ee85ec3b1d30d2789b9a0d00e3972566d"
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