class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghproxy.com/https://github.com/apache/arrow-datafusion/archive/refs/tags/27.0.0.tar.gz"
  sha256 "0ee353b1ccd1adf59f010254ccee419164f2646c34b042df44021b368cdea884"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f4d5b13cdb1165f67a6353b8bf32d5fb4ee3fbec613c72bed46ab6092ff4cf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dde6651b263a34c53852f18976e994531f8fa94040f42fac53f09aa457e9b0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8e5660b5a6ffefb15abeb99026626b78bc2fc2577a4e72dc2d0d35a614e45fb"
    sha256 cellar: :any_skip_relocation, ventura:        "cf485be718768033f52aea7eaca9c68a476470ba0f4c07c76a892d7c19878f75"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b2551f4a3aee2261683e8aa9709bd72a2b34b5b68830ea37d222dae3044056"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa05495bbe4bf7f572f8b1e4fa2f6cef146ca2727520f275e05fbbe1277f7aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71fc84e933f63aaf02149c7150b219f63ab72fbd3f10f59c38a31b22ba101cef"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end