class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https:anubis.techaro.lol"
  url "https:github.comTecharoHQanubisarchiverefstagsv1.17.0.tar.gz"
  sha256 "a0d90cf4fab373ddf8a39c10c19ee4162ce8006d23c2accb3a64335f3f613d6c"
  license "MIT"
  head "https:github.comTecharoHQanubis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "844a4735b49683b7945e8f303433aed2c30529479ee3c9f0642f1a16c11e3599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d0470c63cfbec43aa36ba1dad381186dc8c4ba2bb510081392e0d42ad746e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82b8fbe61d951868d8d1d5c056b24ea8f1adf1a8981ee38106abc2c385e1f9aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c7001e2127a564a6add85aa597b60a888fcc85aebeae898ec9f9c4c9d65e5f8"
    sha256 cellar: :any_skip_relocation, ventura:       "303aca491fc87fbc4732907fbd7d32343fb004cb0abf71823469711692cfafba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c74b3a4eac0b392bab0f476d9a4977c9c59ddbadf57a01e6af5b9b77bc3b1a"
  end

  depends_on "go" => :build
  depends_on "webify" => :test

  def install
    ldflags = "-s -w -X github.comTecharoHQanubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdanubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn Formula["webify"].opt_bin"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
    anubis_pid = spawn bin"anubis", "-bind", ":#{anubis_port}", "-target", "http:localhost:#{webify_port}",
      "-serve-robots-txt", "-use-remote-address", "127.0.0.1"

    assert_includes shell_output("curl --silent --retry 5 --retry-connrefused http:localhost:#{anubis_port}"),
      "Homebrew"

    expected_robots_txt = <<~EOS
      User-agent: *
      Disallow: 
    EOS
    assert_includes shell_output("curl --silent http:localhost:#{anubis_port}robots.txt"),
      expected_robots_txt.strip
  ensure
    Process.kill "TERM", anubis_pid
    Process.kill "TERM", webify_pid
    Process.wait anubis_pid
    Process.wait webify_pid
  end
end