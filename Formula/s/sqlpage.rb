class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "05c0169b02404b1a913223aeb0c49ad4cfa58ebfdc3f489a32b8ca07584fb941"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db3e5932ce969ea6d491bc7f896e0c48c26c1811a905fc5d1a96e7c0bc3f512b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a97744fe597971c7c53fcf37e8283216c5cfb7f175585b73b2be6720fdb3dcd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5fcdc49f3a978d9ed065c0879de9ea2fb8d9a7c239f8c7e80650547519b6fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbe112983e7db8824eda46944c9743d59129e6b8b3f8316ce4d6716a191cbb13"
    sha256 cellar: :any_skip_relocation, ventura:        "1c0daa9b668f8ac1625165d2b7adfa8b5f5f275528620e0c80cabb58a34d73ce"
    sha256 cellar: :any_skip_relocation, monterey:       "df1cf232a3963e9c22f742c3dc49ca74c5188c8588a1ec8dd50e04520783505e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d107d60fcd296f206d170388bace220c8b39619f9d2b3209b0fafba1776c13dc"
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