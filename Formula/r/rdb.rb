class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https:github.comHDT3213rdb"
  url "https:github.comHDT3213rdbarchiverefstagsv1.0.14.tar.gz"
  sha256 "651ca79e423bf0171dc2cbd3ba2baadb7c9529c41d5b6e3a028262026e253137"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44ed4670869bd4c28bcead45d8ae7ba4a2ece6bab6a775cdb5f0781b411b0914"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e63b0cb3c84d3018d9686ce715d07b10d495a1c67091a605fa3c2b3aab64846"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f409bacd57424f87c41119b0533df063368afe5e8aa3e043ca4b9c19170a1b40"
    sha256 cellar: :any_skip_relocation, sonoma:         "06de912654db6c5c121c1743227f52cd5b9aa3e52f2900739f7a64c5dca17df6"
    sha256 cellar: :any_skip_relocation, ventura:        "8dd764a1135c1551989035e8c6c72138a2b49a1bb42bf3b3acf4b42873b8f36c"
    sha256 cellar: :any_skip_relocation, monterey:       "a57246a6cb7c9dd3821acb0b7381a073ace7966bbbc36eea1a9962489fcb0b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78985ce0201fe3a3218122d694c3edccb4a2dc0bbe14294c29141503570d3210"
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