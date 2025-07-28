class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghfast.top/https://github.com/apache/datafusion/archive/refs/tags/49.0.0.tar.gz"
  sha256 "1781d74320cbd7ac6fcf2f6bde5fa893b3f207c1d9564a37a6cb5b72453d040d"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac5488f0a0e25f7fe964c30f6fa568808ed2c3024964ae956fabacdd523bb4a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f512d3d4c361f41d85f7df7d21dfbca83030456cd6ebd6e13dab5f2c7ee67f32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb5cebe1928a699e4ac7ab7488b99e14e78e681de607711b6a041fac5cf7fa44"
    sha256 cellar: :any_skip_relocation, sonoma:        "c65e63ddae1524d75e36979b7271403dda90f3c0e920fef3f75f67969fa84f41"
    sha256 cellar: :any_skip_relocation, ventura:       "8019e4a19621ec94e9d49082f59a2a01b2d66110e6b06bed90f885d4f468c1e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3362e86d1fe1b29fd6fd173481ccc488d1907a0107b95c824d1fea52561df843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4262e53110bb3cc4cefcd47436c14ba375938dc92bb44610d7b123c0e579db9c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end