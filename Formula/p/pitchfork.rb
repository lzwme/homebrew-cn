class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "c2a20d92bb5f62d64efdf8f2466b329017546671ee220c1882457c5539ec8acd"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7dd547678493918e76d87488e7904fca9bb8ac7810f2306740d51811468b9e1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "081c9ac149b762bbb37a794c23fddb514d104a86e215d896a11ced8fb3f9bdcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a7828820772c23b5bf3502a14a4690eb62c2cf71af57f6322003cc5f24a9a47"
    sha256 cellar: :any,                 arm64_linux:       "a27f5f65a81ad333bcef0ba25e966fbba88d5f986ecb25428d3c9bb188153277"
    sha256 cellar: :any,                 x86_64_linux:      "6b7a5fd919b861f21a1964622e79c5e352e1b27251f83f433714f233d7930705"
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