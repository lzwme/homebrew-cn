class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.113.0.tar.gz"
  sha256 "c7adcf4f0782001d258f3a6e4432fc3bde14fdf679b096c85d9f1ea83fb6d55f"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "143c4bab693a56ed0ec8772087519a9e462e6f08d55d5a32ebec3141d590f8f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c501e697575b0d66143115874584602f955ab033c4d1b9f32079e2439b5a8cd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa14e16c3dd8c84642c9017fc5468f78421ce9cd22ccd0386f8af67527d01695"
    sha256 cellar: :any_skip_relocation, ventura:        "ae1b26ad19bd81c150b703c8c563c868645b624abd08c26278cd8a51be5830c2"
    sha256 cellar: :any_skip_relocation, monterey:       "16d500a46eab6a7682afa239e48386227b36fbb7f2567c6dbb827485289a5092"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bddbad4f7226c2c86f53dff0376ff3ba894a5b343924b22522d0552f45059a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baae57fc0c9a13cb11c4bfc73dd0b1aae94b655c2c02c7cbcd3e271cd189683d"
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