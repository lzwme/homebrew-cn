class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https:github.comHDT3213rdb"
  url "https:github.comHDT3213rdbarchiverefstagsv1.0.13.tar.gz"
  sha256 "fcef9fb20ac8a81f3e104b4db6b631e8100977aad63f2a4583da70c9f64580db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "069676a214fe28ce44a97519795f458680e26d05189827ffa2990aa6efa19d45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56767aae07a006f142d25743f2457eaf7b0f9c1cb02129aa0f9fd6b1ea4460c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "158a9405607e16c3c33831cbf54d34ca38af42fe14a3a12a86678b264779a20e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07558d082313d32168785b6df6641a4195383867a83e75fd9cbda6369e6416ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "e47cf7cba77941284663f4c3cdc02b7ffc828c236aa7976d7d9948b686e43e79"
    sha256 cellar: :any_skip_relocation, ventura:        "14af467e44c9422f651094e4e23ec394cf1994ae4c57427788dfddeff2bf4385"
    sha256 cellar: :any_skip_relocation, monterey:       "e7ee9756755da62058987c095ae6caa4d280814f81b30521fe3981f93ce94fe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "53248950ee6af26731fd0fe4acf10b8c817c608acbf2220a3f77084bdb5f5caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05648ccaf20c40be69cfbb03283fd40d7182a28a9bac608f525660b82eb1592f"
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