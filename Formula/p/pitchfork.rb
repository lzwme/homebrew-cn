class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "0de408bf138ea30f4cba9ba2c1be09b4d5c29f394f15c08c7b16503d754eadf9"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73cac7e68a5cd00a8267015f872dee9b3895d7bd5f3d4fe2d8132278275b6675"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "817e448fb961247376bb3d2faa9b14fa8c3e62203243fac2140b071207b10b25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1a273f22272badcc52bbc76798a1de9b53002aedc0efbd56800d515cd0abab5"
    sha256 cellar: :any,                 arm64_linux:       "8f813b97ef6b11eee7697f703ce4644dd9ddc9f4e1f56e461e49fb9af83a4865"
    sha256 cellar: :any,                 x86_64_linux:      "c90857f5382cd960edbcad781de7194c703374ad1669b6f3299b3a9790e402e2"
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