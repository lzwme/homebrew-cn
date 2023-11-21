class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.119.0.tar.gz"
  sha256 "b50333767856cb04cc88154d715861740f912c10156a7a801bd61964e1ee562c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74c2f031c309ee7ecf8961ae43138cd8ffb7e76767bc84c2fe9e21dfe0046ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d1adeb9759ede820ea6f922c1c88872a3c6bbd1846fe33694be8d5b24a00a9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7e4ef6308bd2937c98716adc9bdece862dfb7b86a6772937894e50e29fe8cf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce4a465a0899b9190b942b78a3c062cc091491e7d324dc78cdac3f23b9839499"
    sha256 cellar: :any_skip_relocation, ventura:        "e6638fe9528e55a9054065a3227fdd78fcca46fc8289095df7b50766c27508e2"
    sha256 cellar: :any_skip_relocation, monterey:       "809f8ce864f825e54498f12452082ea5e9b564bad3c6ea05d359b632b5899024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc73d6593496ce6ca58dc4f3e58a5b3805b1512770ad7b9aec69c5f0a1fcdd0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

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