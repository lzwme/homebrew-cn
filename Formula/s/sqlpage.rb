class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://ghfast.top/https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.46.2.tar.gz"
  sha256 "f5e189b300dcf474c7f4b58d0ef484cb2acefa8c633b676147395c79ef51e14f"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1961c1638c341e93676bed58c35af471ad486b1a7f5a233e0cf3d1c1bf8e7359"
    sha256 cellar: :any, arm64_tahoe:       "03f0a7ce2bf0e2ffd8e3b8b14f09d7055193079b252d57a080fdd0c825ece915"
    sha256 cellar: :any, arm64_sequoia:     "238f2ccf5b66371d71cc844db9a1bf7235769289dd67472c13673a8d709811f6"
    sha256 cellar: :any, arm64_linux:       "f513953bb7176ead81b0fa3919d1a4d107cbc88daf5c13ffaa7c1c02e5e35ac7"
    sha256 cellar: :any, x86_64_linux:      "fcaf6c15d7b522c54f1f7fec3b7944f6b9af5ebfd381bacc5a6416c38bce6284"
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