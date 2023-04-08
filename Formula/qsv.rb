class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.98.0.tar.gz"
  sha256 "9a530b6bee7772a141b0081ba406a96ecb91460077141717652d905931e4fb9a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93c0816be37977fb8b2580fef6b0af57720e8cbb5e637719c34e0da0f6c7fdfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ade08172698c566f98e9842404142479f2c0b49b2588f932a384d4defb5125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11dd95d7cadfb5f5c59d6d10d09096bf205d69bc185e30ac983fa0334c2a7ef5"
    sha256 cellar: :any_skip_relocation, ventura:        "f5af67ed554693a51621e9a2730e7b3e7b5cdb0a181a6474ac8d1f65a060e260"
    sha256 cellar: :any_skip_relocation, monterey:       "b391a09e2931ccf409c6ab12a84c0d2a975641e9c62a6f354eb769b5d0cfb948"
    sha256 cellar: :any_skip_relocation, big_sur:        "b43c2a9c8dad83d70d8b4f2b66635d0fc43040a067d6fba6af410107f4390d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65567e665ff51cd910f8d9e5190bc09c139e47b1a468d7c40f6977d62034af31"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end