class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "8face034bd8564020a1c3cadfb91cba09431d0670c43d794320b550021a108f0"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcffd6937e6eefb18a288d47ae43d4520d061b29169cf6d9de6d6719aa9c24cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2eb123217c852f4aaff998126c48605706aeb99523abd6640a55c4a982f22e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e33bf6c51c0bc31ea8aaae42cdc44e755be00c97bb19c8e0b4c2ad5129c4cd1"
    sha256 cellar: :any,                 arm64_linux:   "e161197d4f9d9c7f3e64bf577df6303f59ca09119324c5f29e7fd9e49396b5f8"
    sha256 cellar: :any,                 x86_64_linux:  "401342c79d239ba0035e0c7e0a57448678c8dbb9f3a5683830df8c51e1c3a65b"
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