class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.110.0.tar.gz"
  sha256 "37a483de56840e9edd8c08d162f486edf6dc8b836701f104494e874d7a62af23"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b63d13e96eec2d8934d581a9371b8a48a170aab50382f8d070a9721a1bddc40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3fd4e2b9b6a1ffefb0c1c421c34ae48132abbc64527c91caf1587afd361fc18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86baf35b7834175642149e7abeda18859ef7a9a02c37c10e329eb9e4fb432ae5"
    sha256 cellar: :any_skip_relocation, ventura:        "e7541666bd8f160991590dbf3a41111aa7f2a817f68733f8d9023e850b7e668f"
    sha256 cellar: :any_skip_relocation, monterey:       "fad3191edb397d584dec72193a854033df59ae16d583760e0265ddf754f88617"
    sha256 cellar: :any_skip_relocation, big_sur:        "003f293c0cc9711d7ab7832887286d0047cc6a3b34dfcd86805256385da5e584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dfab1006dbb13a87f646866e784876494133ebe1cd7fed40f70ffa86a355099"
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