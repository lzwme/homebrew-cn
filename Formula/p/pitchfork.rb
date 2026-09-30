class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "0de408bf138ea30f4cba9ba2c1be09b4d5c29f394f15c08c7b16503d754eadf9"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33acb67da4095417e3e4772f279722ed5e8193c048903b916bec5426ee58fc7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4e3fc81807770594a5ebc0585397bba75eb38273534669c7c6bd965ded2ab74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87b8a96e14e61f617b9b5312310ebb1ad23823868d40f7fe295ac28dd06d9122"
    sha256 cellar: :any,                 arm64_linux:       "eba40af4304ae8703ed2f10f171f409fe62d0841133840518b03a7f1176971fd"
    sha256 cellar: :any,                 x86_64_linux:      "4c7a4079bdff474c8eccfa7a1a221349413dfb84b3cf02e4083d705500a42b8a"
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