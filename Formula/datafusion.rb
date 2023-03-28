class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghproxy.com/https://github.com/apache/arrow-datafusion/archive/refs/tags/21.0.0.tar.gz"
  sha256 "90ba0bdad5b209ac55ae750d6b2498d271d72953cb819067bc0ab56ba4615a5a"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "500e856370bd85662356f3de0542565e6ad6179c8ea2af5d2817c5441872fd99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e635b919647f01b05f008aa7b77748703f60b91dd537a18716a3ca927a56404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f1a68f3f1530200c679437db0b33dbfe676a2bcc367f52704190b07ec9e114e"
    sha256 cellar: :any_skip_relocation, ventura:        "6065f50b080875b08d40d8ff6214d91c9245eabc0e270111f92b1a2c3bb568f2"
    sha256 cellar: :any_skip_relocation, monterey:       "9f5c787ffb120672ba3bd80bfdb54113f36df1d11bd0e7598c5aa7153663b810"
    sha256 cellar: :any_skip_relocation, big_sur:        "7573f3cdb8ea86a27bfb96e6d2f6695508fda012148c6be2200a1fc07201b096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb9b951ee337d68cd2e0e808b213756fdee018bbf6a0e52e8a83e77a39324ef9"
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