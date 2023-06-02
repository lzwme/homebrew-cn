class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/v3.16.22.tar.gz"
  sha256 "20b47c9f2f566533b4a43ceb5354723e5007046ac1a5e3c4527f39d268f3c06c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3be84c083adbb083a20d48da57ec6765bad44a2760bfdb712ba7b5a1f11c1b36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eca5ddcc873206ffd6fb80b842f926280c933f410bf254f99663f2c10e9c1a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d86517f119ce1100feec8b79753a530effade7e14f72304d1aaa229030a4bd6b"
    sha256 cellar: :any_skip_relocation, ventura:        "995ae69248dad2a17c3f68ac6272e3ce83a436d03652ef96a97db1c060b3cf24"
    sha256 cellar: :any_skip_relocation, monterey:       "29605c3a90e17c0c3b1ce90412650c5736e8bea87568a3868a07153df1497b46"
    sha256 cellar: :any_skip_relocation, big_sur:        "1731ed00d83b9504c5cee74b79ff686b772aa8925ec59803876af67ae59e41bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab235069ddd932345a9aa4ca83e937a3df440ecea12004aa854683a30d2c370e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end