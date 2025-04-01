class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https:anubis.techaro.lol"
  url "https:github.comTecharoHQanubisarchiverefstagsv1.15.0.tar.gz"
  sha256 "575cd22d7504c1aeb77646a1b0e1babe9216c18da22609011824091c134afa6a"
  license "MIT"
  head "https:github.comTecharoHQanubis.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2241dceebc74fdf932b603b8814ccf376b3cf3adc73c3443130370a87a2524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e349d7bf471af558c873ea8136bfbe1d8e7392407e6c98431a2fea823eeba7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "708416608f6f95c0456a1c67fa33e9f12c019d05097135ed0f1625c0ac31f5d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "df1d1333625ff6fdbfacf5eba3b70b375c8167daf841d98b910d11381479a405"
    sha256 cellar: :any_skip_relocation, ventura:       "b1478e8576020db2763777f5209105e1537b9e97058d8e6ed0ce2cf60e33efab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfb88fb1317d933bba2c27e5a2338cb0b6f734100eee4ccc9362808dc12db9db"
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
      "-serve-robots-txt", "-debug-x-real-ip-default", "127.0.0.1"

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