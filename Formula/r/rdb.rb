class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https:github.comHDT3213rdb"
  url "https:github.comHDT3213rdbarchiverefstagsv1.1.1.tar.gz"
  sha256 "ee08a3ce6e51e8118b8d1a57b58a31c0d32bdbbe2f1819811be1611b3a6ee7bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ccadaf6325a8df36bbc8dd990a151cf5d8a60e541ef868343ca244d581283a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ccadaf6325a8df36bbc8dd990a151cf5d8a60e541ef868343ca244d581283a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ccadaf6325a8df36bbc8dd990a151cf5d8a60e541ef868343ca244d581283a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad2b5504f4719cc10c90ebaeedbab2443a9a21543773b9382b806030a20b644a"
    sha256 cellar: :any_skip_relocation, ventura:       "ad2b5504f4719cc10c90ebaeedbab2443a9a21543773b9382b806030a20b644a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dcb38aa5aa2e6f4b184ec385a4fe05f8f3bba479e73a2542577cc8e3c57d23e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "cases"
  end

  test do
    cp_r pkgshare"cases", testpath
    system bin"rdb", "-c", "memory", "-o", testpath"mem1.csv", testpath"casesmemory.rdb"
    assert_match "0,hash,hash,131,131B,2,ziplist,", (testpath"mem1.csv").read
  end
end