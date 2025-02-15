class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https:sql-page.com"
  url "https:github.comsqlpageSQLpagearchiverefstagsv0.33.0.tar.gz"
  sha256 "32a6fc9e8c1c41a50a1b64df35b5b1bcf279c3f647a65279a466c7b0d62973c7"
  license "MIT"
  head "https:github.comsqlpageSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272bfe9898241a2b108f81ebf3341366fdc4c9c7da795b9a64f36d2e251bf749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c46f69f1d9e1a5c2258c4b275997ada4f7be3437c438dfacdcc275b5a1e536a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b85bf3f143758ac1a79e83be47e92244882c2266cf1e4e899a6bc9894e32a00"
    sha256 cellar: :any_skip_relocation, sonoma:        "262f06fe4da4aa4f898c836fce499e6ed0bad54fdca0e4e10d79b380ac58b17b"
    sha256 cellar: :any_skip_relocation, ventura:       "f6491ca63c2caf4c1fd3a123fac59cd7c12d701e153389cd813213a13e5bb462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7376d9ef646e04048229a7e7a839cc985c7726dd1b7bb11f9415e007dd1dbfea"
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
    assert_match "It works", shell_output("curl -s http:localhost:#{port}")
    Process.kill(9, pid)
  end
end