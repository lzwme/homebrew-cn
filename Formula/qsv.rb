class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.95.1.tar.gz"
  sha256 "38bedb77849867e9689870074351642e6027dce38aa2be41443d494b11218f91"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9535be1b534674a74d862cd84fa4ffe37665a76adc95f310972ab652285c49a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c08da6eb9b9f8a47939901c89a380c98043319dee8f3877c52b74f566efbcd77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "599d0bcc4dc4befaec4bda119a7e8ecfffc4ffda451ecb137be499b0823ee175"
    sha256 cellar: :any_skip_relocation, ventura:        "5348bd3987543a7086cc9e338aa42b1c778525feb2291fda0fb9a4c78e94b774"
    sha256 cellar: :any_skip_relocation, monterey:       "b22d25492e92d24234eb7a53c41b80341cdaf5f639543563c2480c2a88f2eece"
    sha256 cellar: :any_skip_relocation, big_sur:        "eda778ec967220dc005ca437dcb6f1c6ddeedcd313e6ad61e0b6fc252474b361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de23a1576f2b7a9d43648e2cf7972b2efdc0ed34260da7db36409fd038502442"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,full"
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