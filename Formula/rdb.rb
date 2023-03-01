class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://ghproxy.com/https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "e23ddf13155535622b3244ae0366135f1dffe3cb4931db02710374f2c24bec31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4961f7b192dabf9294c3f7347fcc9ab67c0df979b8ad3b2aa861e740f2dc1c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1c58f1c205514011865207012f8191392b08d29453c6d728cb6788459e455c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fcd3c426468fb35a419e6233fcdac61c31ccd8f66e54fb89a9f8ac56bdebeaa"
    sha256 cellar: :any_skip_relocation, ventura:        "9ba8b0c40e711092e3d571ca64d09d7bb72df457de915e2bb532a1dad528b703"
    sha256 cellar: :any_skip_relocation, monterey:       "8622cbd7908ede97b5113c0c4e0d5c8ddb28f0be9c05191c5a6fe5124df96c28"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e00f858f59db0cefaf3034c2115d93f8ae5d14e33ae4e4f6b47affb40b82b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56896b55595be0aee14e814730f41c9d8b81f072cd2f549c145234bcc6b35dd0"
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