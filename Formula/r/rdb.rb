class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https:github.comHDT3213rdb"
  url "https:github.comHDT3213rdbarchiverefstagsv1.0.17.tar.gz"
  sha256 "f810af73c6285c42e9dcfafc5c84329bbbb92e0db6c0e622d0d84222bac94bd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17c450256049779ca908268b922cabe95884b05cbbb1a2817ffc16b4149b2f1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17c450256049779ca908268b922cabe95884b05cbbb1a2817ffc16b4149b2f1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17c450256049779ca908268b922cabe95884b05cbbb1a2817ffc16b4149b2f1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffe4b2a0ce294209c6613ed67758ed6ef661495a7fd741b587023c6fd02ad6bc"
    sha256 cellar: :any_skip_relocation, ventura:        "ffe4b2a0ce294209c6613ed67758ed6ef661495a7fd741b587023c6fd02ad6bc"
    sha256 cellar: :any_skip_relocation, monterey:       "ffe4b2a0ce294209c6613ed67758ed6ef661495a7fd741b587023c6fd02ad6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b1313ef0ecc9dd3a16a990fa155a4edcfa38e59f5992a12381eb9723939099"
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