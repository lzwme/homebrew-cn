class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https:github.comHDT3213rdb"
  url "https:github.comHDT3213rdbarchiverefstagsv1.1.0.tar.gz"
  sha256 "88a56e1e022ea1522fb68e3e54e4dc603827494d994f4b5a24ae8c17ecee2069"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df85087cc26dfc1fe3eb28035105bd3864ab82d9645746e9ad029e11b786eb01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df85087cc26dfc1fe3eb28035105bd3864ab82d9645746e9ad029e11b786eb01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df85087cc26dfc1fe3eb28035105bd3864ab82d9645746e9ad029e11b786eb01"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5e4cd239b3856d8cf3622dca2448af48905288b1a26586c83f0f1168ebb60a8"
    sha256 cellar: :any_skip_relocation, ventura:       "e5e4cd239b3856d8cf3622dca2448af48905288b1a26586c83f0f1168ebb60a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904c8ae38c8ae716375f9ca5927e60fb0a5b54fb216d21b6670e3d0ab3ecd519"
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