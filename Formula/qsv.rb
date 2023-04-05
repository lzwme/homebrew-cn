class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.97.0.tar.gz"
  sha256 "825f7afe68afd185d61ec6102114f6b24c5a5dfed8f482acbd9d77657649ed1f"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da7fbfacc852c53e48f91c00f65522fe04b62f6c50e325767859bd88bb020286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36d7aab75a9c66ff935afb1f3a16172c59a76656d32e1dca9f137529198297c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec760afc4c557d172427f3f17531fca97235d7cbfd07dc195b1130707ce671c9"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd23b596ba2480090069fea73c0c5946ffd9d9538168ea69053159ee9617985"
    sha256 cellar: :any_skip_relocation, monterey:       "5a58a11c9dac6f070384b48dfa3cd401175fe8b7ccd8b968f74e04a3a0b9cf51"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bb3ef28f38df2344d55a9c0d05cc073f5f2318acb80a5bfa9b747ff0aa06128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d979faafb28d16c3f9e73211f8d0ee3481c0a0745ede99ebeeba4e7c967a6c61"
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