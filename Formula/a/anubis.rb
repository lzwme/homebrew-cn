class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://ghfast.top/https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.26.2.tar.gz"
  sha256 "1a814ac0577f502a06664f49c6d659959a2428813c3e31bf33fc3038deeab700"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b9191fece8bbd62284d9ae22142317b845f98b4e37531b0b70bfe9b934ba5d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3219846fa609d7cc3d63eb2bad95e70b7a10192b5bc914fd0d83d4e0b48000b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2f87b47200eafc857c4914875ba350d8a28d24cd3d8026876af6b399e6e5ba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f27b43b07d50b4becca5be24451214527068d04f39b33abf41927f7e2e4f30a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "454301a6160a8fba4d7db50e7b83e8f52c2192672a6a2f93c98bc819875b4c9f"
    sha256 cellar: :any,                 x86_64_linux:  "2be8b332c084280eea9db58e8c383b526f6199273d581f75fd10f5391e67cc82"
  end

  depends_on "brotli" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "zstd" => :build
  depends_on "webify" => :test

  on_macos do
    depends_on "bash" => :build # error: shopt: globstar: invalid shell option name on macos
  end

  def install
    system "make", "assets"
    ldflags = "-X github.com/TecharoHQ/anubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/anubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn formula_opt_bin("webify")/"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
    anubis_pid = spawn bin/"anubis", "-bind", ":#{anubis_port}", "-target", "http://localhost:#{webify_port}",
      "-serve-robots-txt", "-use-remote-address", "127.0.0.1"

    assert_includes shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{anubis_port}"),
      "Homebrew"

    expected_robots_txt = <<~EOS
      User-agent: *
      Disallow: /
    EOS
    assert_includes shell_output("curl --silent http://localhost:#{anubis_port}/robots.txt"),
      expected_robots_txt.strip
  ensure
    Process.kill "TERM", anubis_pid
    Process.kill "TERM", webify_pid
    Process.wait anubis_pid
    Process.wait webify_pid
  end
end