class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://ghfast.top/https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "f3da5414ae9d2ce57271ac8b59449cdecec53b1083a924af470ce7353e4d1ddb"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a5f09485c74f5658b77b2a8246cfa4d47c7b31baea4df5d9432e098745594bd5"
    sha256 cellar: :any, arm64_sequoia: "f7297adda22aa96c2e7a58e16ee6503a8d82abe36da5d6edd2f7d8611b7188af"
    sha256 cellar: :any, arm64_sonoma:  "c7193e7df704730e4a7bdf72994b219cfa5845a8922df721041af116df98ce66"
    sha256 cellar: :any, arm64_linux:   "63008be1ca094394a31b253b48b76841fde3e6cba1ffc12586267b3e1cb787c2"
    sha256 cellar: :any, x86_64_linux:  "a86f93e8e7bee62a251609dec01fde4222260d9329b13bffaf7a574487f589ea"
  end

  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    ENV["PORT"] = port.to_s
    pid = spawn bin/"sqlpage"

    assert_match "It works", shell_output("curl --retry-connrefused --retry 4 --silent http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end