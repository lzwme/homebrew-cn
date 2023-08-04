class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "2f93224acf85b247765f994826c53e555f52a515ddc054c98bdbdb9d5f54d917"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28ce3765e67dade042b572530cf4763fe3decbd22c6ef7f3b201eb60e5f3b41d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f9dfa9d0e1cadd3cdff0912c5dc6412ad1ce258e32ef26941c2cb278d4ced14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb1729c4326c90628cd6a79877b425fc229becf182318a52e8ab2f988df7e7ed"
    sha256 cellar: :any_skip_relocation, ventura:        "1b1527fb446af8f934dc131fc04abe3b6fa4d6a87e58b1f5677c2e29be9bf8b2"
    sha256 cellar: :any_skip_relocation, monterey:       "c43936b5a1676855adb126be6ba96a6e8f7f837d1dfc109e0c6a4b7a0af6085c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a2a6c4d19e72dda29a1862e1ccea21dbc7cebe65c76e03cdb035e31fd096e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee45b13837fdfb6a25ceea66b80eb16725f2082af6164a402b7ad568201f764"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end