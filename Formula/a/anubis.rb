class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://ghfast.top/https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "0196f0a867685109917b4ef9ee3414d212bcf2675f940edd5ef2ef121a7a71d6"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92fe08aac9d759cbbcb8ebffa26440e93ed9816f4324d78721d04812ba0eaf44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0191d2aca72466959b0546b781255db7ad28e75a5660a481f45540d1858db1d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03e20933b3253c90457a99f64c9d6c6a298ef42718aad7eb3d78a8f5f1faadc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91822dc7fe3696fbaa514e0a13de6482250709a0d4997ee73da0e6310e2d35d"
    sha256 cellar: :any_skip_relocation, ventura:       "6671f8297dfd4fd59e33b318b0c722e16f2c44865452f00a3e2bf52c08cd2d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2e82f0ec8ef8b7c86ea95e39d220e8819415109b2ef427e11ae122cd540ea6"
  end

  depends_on "go" => :build
  depends_on "webify" => :test

  def install
    ldflags = "-s -w -X github.com/TecharoHQ/anubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/anubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn Formula["webify"].opt_bin/"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
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