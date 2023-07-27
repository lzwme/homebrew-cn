class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.109.0.tar.gz"
  sha256 "c48d7f5a174d3f80781ae9feb16173d6c5058e4f50916ff2dd77e1ade84a4dbc"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d06648b003d2960121eef5846d76635410851cac6260747b906e241ee422805"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06ff3a693a60226bef712bb87bac954ae1fdc764e777dfbe2dbbff2c27c36d03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93bdbd6bbdb9ea00e40fa5173a1bfc20019b48c53fd968ff7f5ca8a591b0134b"
    sha256 cellar: :any_skip_relocation, ventura:        "5ef919665eecd934091224dbb515a54f6c622ff420c447f4ada39c52de589de1"
    sha256 cellar: :any_skip_relocation, monterey:       "127faf41a9985187a77f53094e3cb1abe25504fe9525f60f179aace2b801444c"
    sha256 cellar: :any_skip_relocation, big_sur:        "85524fb65341a0e2a09055b8e6bce48ae8c26bd745fe924619aae229d3305935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460da51a0af8168a6657e467763734497d48f150833c39abbfe5c20dd5a14b92"
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