class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.32.3.tar.gz"
  sha256 "a4a5afa497c9c59c0c0bf39b32ff0fe1d7302e351ac03f135d5986a1aa390438"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ae5b8cc4da97dcef216e729d0bbeca92117703395f6f58552aeb19f1cdef512"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0d8f5046a9e5c840d61db97b8b1ad2d51f8cfd22283438c7e685c61fd2ba24d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b53313a1bd68e5fb643e045a93e6a2018d93d30050eeefb7258a31646b77b6d"
    sha256 cellar: :any,                 arm64_linux:       "cff5d4d24e9287ea6275211c3103a24193233666fbabb18366dd7ed37b50a5cc"
    sha256 cellar: :any,                 x86_64_linux:      "68f3d0b1996b7c01a73013beb2be0e989b9afc7f60cfacfa0ab9f483d0ea188d"
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