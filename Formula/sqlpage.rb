class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "58202e72a5e3c1f81a129948b7b5127cbc56c0c14d9b36687bd6032e9d2085fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "172e8323e121436cd95b21604484021f888a669f1c613203bbe5e467081ebfaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1685add040ecb3924e52232fd1665d4e733bb97391261394271c68cf35595971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ecb7cf59c9973d5d3217c41a93b67b10295255c30ff4155e5aedc94d480d553"
    sha256 cellar: :any_skip_relocation, ventura:        "e1450e60bcd2c605b9901524f9a0656836e19bbbe596add1939e47aa63cc5b4d"
    sha256 cellar: :any_skip_relocation, monterey:       "ac8924e38aed81bb262a8e2aa5fbfa603e1ed4e8bfd8ef4b987fda07a7a1fa65"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d2ae947f190ce1756738d59d08d4c7860c8ac92fa92f48908e40a0245833a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd32dd5a636ff05e4494ffead800aecc1d1eaaddb08a5a1e21a3ba8bf3a70971"
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