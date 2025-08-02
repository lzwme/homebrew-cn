class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://ghfast.top/https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "76266a82da0010d97c8806a2223da412b6ee57b1be025ef051e0c70b4033bb7f"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa1fc0f95116329e2260a8c550feb9476ed223c72846eb91328d999e5c18d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2d3339f7a33c0acd4ba9ebdf3782ee94fe9ee67de7cc610305a516af144cc76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24fad274b28509e161bebabbdc645f639779879fcd787c55af8f207a78c446b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b851c62fb121b97a0df9441bb3764a6837bd3d79e757b171662ce0b0a051887"
    sha256 cellar: :any_skip_relocation, ventura:       "04e3c510ed5a91f8fc20b8e4241f09c509b53fd370e96b2904820d538dd54dfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94ea1cfe02d3aaa0cd704127883df38e17c2243c2ad07df0fd7f257140783d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d43b800bafaf31d8ed864919cd02fb5903116029f4674ab86e373d1929fe652a"
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