class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://ghproxy.com/https://github.com/mithrandie/csvq/archive/v1.18.1.tar.gz"
  sha256 "69f98d0d26c055cbe4ebfe2cedf79c744bebafac604ea55fb0081826b1ac7b74"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4da92f08fc5206cb67e4748463b1d29289da9630dd5e3b5e394063ff48e465da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b40bdb339f355cea536c697d0f1990c20e6ec3bf9f606d50a3c494b56ef23a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adcd391cbcc84b77d0ada56fd670bd511eb7c8adf2b516ed185809595b4bcfb9"
    sha256 cellar: :any_skip_relocation, ventura:        "3062a442b7fbdfe309ca430277257a6f9a86a6b98e4f3558f6342d56278e2a37"
    sha256 cellar: :any_skip_relocation, monterey:       "39141ce5a0342df70a2546b77a1800f9e4e4e71763d4464a53095009b07dc96d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2ab039ef6309cf727c9b908609c64d555539649c051baa792ccdfef3cc9d5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d32956ca38f3f9d768739765fc3f7f3449e0c8f67d45dc2d55981e93fcc8edeb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end