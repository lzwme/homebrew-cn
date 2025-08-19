class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghfast.top/https://github.com/apache/datafusion/archive/refs/tags/49.0.1.tar.gz"
  sha256 "d652394ad936f2c8a88ce16c17dcd257fddca72146666399b6c33c091aaa10b1"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eba76ae598cd73978a8be313cd8bd992d20610362db2ccdfdc41b955672366d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d40df56c33f6e12de228f5fede828d23e453c9a6e225345cf5afe89271a924"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c15ef524f0f6c6e7d7ef992a5e2ab5377c9338f2de76b400f7a3f6a7dd4552b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b7f2b00e48a52b6943292328edb86d911ba2fc25c75ab56651783488e8b0b95"
    sha256 cellar: :any_skip_relocation, ventura:       "81bdc97148874f1b3208db78fb50cddc73cdaed9a675a02ae7efb5164c2d7edd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b7e1e269b81db4b495920defae7833113d8f25f588119bba89945603b965312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da4af041949ea5b658290bc1471cd771fff522074143d4dd5d90e93c40a720e0"
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