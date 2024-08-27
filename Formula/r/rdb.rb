class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https:github.comHDT3213rdb"
  url "https:github.comHDT3213rdbarchiverefstagsv1.0.18.tar.gz"
  sha256 "028e1bc6e6f4a71a6355676e290f5ad035019814af8b867e4f59c67a6bac154e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88c0e4faa32ed73f89369445ce46f2d25b83a4e5a3356ca91d061af9a9d4d382"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88c0e4faa32ed73f89369445ce46f2d25b83a4e5a3356ca91d061af9a9d4d382"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88c0e4faa32ed73f89369445ce46f2d25b83a4e5a3356ca91d061af9a9d4d382"
    sha256 cellar: :any_skip_relocation, sonoma:         "b696a5e5d687b9578ca5520779c971ad824eaf56fd070ac9f8800a67fe560893"
    sha256 cellar: :any_skip_relocation, ventura:        "b696a5e5d687b9578ca5520779c971ad824eaf56fd070ac9f8800a67fe560893"
    sha256 cellar: :any_skip_relocation, monterey:       "b696a5e5d687b9578ca5520779c971ad824eaf56fd070ac9f8800a67fe560893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247da86f4c3b6a03604995d7d07e1fba8561f6908fc8e0d7d68ab3bd55d6db08"
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