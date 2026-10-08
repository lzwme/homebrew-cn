class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.30.1.tar.gz"
  sha256 "3038e9bbdcf450acebc9e5a65bbadc638778dedda5e4522906d9284b98283bfa"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a36323522c5d35ffd9f9fff8df5ea7fc1ebb291195fbd987d202334df82f300f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "426c05477e83717a2f9d80ee20cd6710d98cbf467883014e4458a2deb5ac72e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75a3a09c44e55f5c9a4d4f58452b767062f26f42fc7b76cb1ca903ae6f7ca6ef"
    sha256 cellar: :any,                 arm64_linux:       "30cbdb60f4b09ea101b32ac52a80a7c6660962e3ba66ccad74e28fa37558f39f"
    sha256 cellar: :any,                 x86_64_linux:      "7030cd672eff35e2e7abf42b247ff6d644f1eca8f6df8eaf65c36c9cbb21eb21"
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