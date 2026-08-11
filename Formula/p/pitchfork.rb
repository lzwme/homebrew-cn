class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "025eff41b584922d3668c0b7f01b988d5e561abd19aa3effdc621ad64bac5d3d"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "895709bf464c2529f25207b40e5c65ccbb50950553c43342460ca4c0b23622a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7bae50ffc3e194664551c4a40b7c5d0411ec6a9b24e85b6f5ccceadb371ebf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e03542029f0ee257763bd955b0c20cb78e9332b4ad0248110aceea4b8aa02187"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c9723f0cc1f79147dc63dfbbcd1a6a81fd4fd9af5d0fdc48d955ffff7fd3c69"
    sha256 cellar: :any,                 arm64_linux:   "257733e98da9b579e72f649448c55b32169ee034eb9c9ad2883e25a07c36644e"
    sha256 cellar: :any,                 x86_64_linux:  "fd9e0c62c2cbf027a316af9190f6ca6cc0aaf30cd3c4ff8071bb7d65191a72b2"
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