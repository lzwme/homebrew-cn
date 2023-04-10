class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://ghproxy.com/https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "d8a69ccd5eeeee7008d4efae66e83230478853e16989c8eb373cde9c9d68c736"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c4d8a443ab8d9c20291e97b38a6cd7b40b2c64e9b8be44a2ebe9200a37a15f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c4d8a443ab8d9c20291e97b38a6cd7b40b2c64e9b8be44a2ebe9200a37a15f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79c4d8a443ab8d9c20291e97b38a6cd7b40b2c64e9b8be44a2ebe9200a37a15f"
    sha256 cellar: :any_skip_relocation, ventura:        "37934c304a2c25b5d37ca0b5381c9eb3bfdb04d26872271ef9369b29abb5f76b"
    sha256 cellar: :any_skip_relocation, monterey:       "37934c304a2c25b5d37ca0b5381c9eb3bfdb04d26872271ef9369b29abb5f76b"
    sha256 cellar: :any_skip_relocation, big_sur:        "37934c304a2c25b5d37ca0b5381c9eb3bfdb04d26872271ef9369b29abb5f76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86759c21f142f76baeaf4e7c60ef7572ba11bba66d411e809815033a0b992320"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "cases"
  end

  test do
    cp_r pkgshare/"cases", testpath
    system bin/"rdb", "-c", "memory", "-o", testpath/"mem1.csv", testpath/"cases/memory.rdb"
    assert_match "0,hash,hash,131,131B,2,ziplist,", (testpath/"mem1.csv").read
  end
end