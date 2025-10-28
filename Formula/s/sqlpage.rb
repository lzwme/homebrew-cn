class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://ghfast.top/https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "284e798324c6ef613b1792f24ba0c3bb1a589bb5534671fe863ec625667ec09e"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3df5bd2e0281e18a626cfd0e312a8e988923d1de827e5ac86bfcb93029211051"
    sha256 cellar: :any,                 arm64_sequoia: "d0f3bff9655f1ec34527e4c32ef58861fec08ca8453328c75da10ffdb270d734"
    sha256 cellar: :any,                 arm64_sonoma:  "e6b4471c262f287be8c85a8e7b428066755d92cba3e8cc238de013ba67eabb26"
    sha256 cellar: :any,                 sonoma:        "1f57aea84ab0bd9f9475480c894cef1e4062acc81c50697d7f296ba38b4a5091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ddd923c8f8c49472197499a2f06ec0471126a85fcbf10fc202dfc04af0a4bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec05575975fe9cf29820e9953e44f0cdf1638c1434fbf862c6a0816938faa0ed"
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