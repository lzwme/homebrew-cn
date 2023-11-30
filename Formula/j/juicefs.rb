class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://ghproxy.com/https://github.com/juicedata/juicefs/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "43e1df896fc4c32c8c5ef75b418bf08dd27ca0a078c7e01d2a8c17db57f2028d"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6991e448bcfdd3392fc7047d7558bf60131d31851c1e2d1af620976230020a54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b503dfb8991f02b1a0c5e6581ac15d76033da8e66bae8f826258da94c94bc32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd9f9a2c4f883723777f15f495737037ba71e0ef45b959fb2540fc20e567d285"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3742178f10a9a1e95b00fe61ba44af5d9da1b739d83da04769359594974b392"
    sha256 cellar: :any_skip_relocation, ventura:        "f3dc437cad218ccd595aeddaf60b83c2df289ad842b5aaf8ad19e917e7c85028"
    sha256 cellar: :any_skip_relocation, monterey:       "3b823e6214fe5195577a331533d638707633bd4dec1cf48ac8810dc54b36d350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00a8b341c88b76ab61f28da8c7892f8b50e31373c5588d6a832759f85e179a7"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "juicefs"
  end

  test do
    output = shell_output("#{bin}/juicefs format sqlite3://test.db testfs 2>&1")
    assert_predicate testpath/"test.db", :exist?
    assert_match "Meta address: sqlite3://test.db", output
  end
end