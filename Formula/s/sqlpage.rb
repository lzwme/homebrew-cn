class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://ghfast.top/https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "08f4a7be79fe602009aea653725f4d1ae6fde01bf57dcf418f9c9fc8669a98de"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce0ad2bb380754698289f1231a73d02090cabd8a28ae3780b6d99f76f4adfe2a"
    sha256 cellar: :any,                 arm64_sequoia: "259f10866f01c2a924bd82ee74ad167cf6720b04f8b2d2997292973b0d13d181"
    sha256 cellar: :any,                 arm64_sonoma:  "8d5a83af862200c39fe8ae95af2e297f624c66e1d8d84c11e7f3c0922666aae6"
    sha256 cellar: :any,                 sonoma:        "705a6de5b05cf4f48820d3dfaf04ec4b2cd3041f671b704a4fe47b5e53baddb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd198895763795d432ea30246f7deb15788cadb71d5f33662edaa23fe5d0bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff14bd895c6e7623a5d2174d79cf5b8e5f2f07fb307b1140c017ad8e757be17"
  end

  depends_on "rust" => :build
  depends_on "unixodbc"

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