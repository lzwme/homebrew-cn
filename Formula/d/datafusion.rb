class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghfast.top/https://github.com/apache/datafusion/archive/refs/tags/49.0.2.tar.gz"
  sha256 "654d63bd82fc05cce626a663d7cb97e646e5ce5927bdb682d8fe12f8b163b936"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2b560877cb303c33b6d25ab86f5149364de43838501bc071cc84af950bcff65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fab546713a39da80d94bddaf61f74e987e6017a57f203bfbfae4d394ee76a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db8c0dbf58f94b24f6a2a5e47c027123e2bcb2e314c43ecf4abd43b912dde445"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ac8a05397ed16dc05b80283f666547b04217f2690a5bcc5dcad6ec3ac136b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "f69728bf6bde83c03539eca23073082f2e1e953864fc2230dc706928b56d3fd0"
    sha256 cellar: :any_skip_relocation, ventura:       "38d6f279cd60a67f054041f9960f8b34ffeb21c6215d410afb383726e60441f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55cada874e45efc796f04ab727fb0ca8d302145aa9d2ceb81ec5f13d8d8f9335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c5bf218fd704d50691f2fedcf884424e47b4058dc47a4c00e3f1873ee57dc7"
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