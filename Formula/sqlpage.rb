class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e7f1d46a481331e3f26cb2effe00e5bd950e247656674892203d1cb5f8dd58c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c654d8997dfbbb6b43627a368f4afc604444f0e7f883ad45d92a83355229632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08dc81f85276a29b7409807d04af0e72d996b823aa7ca12d3d6fe2d980c821cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ba2131ef73fb56994d2a7c086ae9c809736b801f2eb3c0da7d3c1c1567d2421"
    sha256 cellar: :any_skip_relocation, ventura:        "9d9d612dda7acd8f1768becc1028878644b8b01d242d03675481e337540dc00c"
    sha256 cellar: :any_skip_relocation, monterey:       "529a75c46c35457887151cd9ae59de32c9c9fbab571d831e43b7ecb9b428865b"
    sha256 cellar: :any_skip_relocation, big_sur:        "863835d37ca1b40d8d4449e2942ecf0cf7ae95b17c74c62967af98d0a6bf23e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca8968db8e4c4008f9fb0ac6f03c4f323738d898d45508868b7b0c8922c36ce"
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