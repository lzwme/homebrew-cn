class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.103.1.tar.gz"
  sha256 "6c67f0eac5e011e94cd8d034c7e9d519a6eeddfad5dba53abc6d91aea55ccd99"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bba1d5c9e16cd7d223900587233db44af2a050b59743e78cd8ef7bdd55338199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26c6e842adf098659b97cb31f0063ae70589f2305c951df529380826a2049668"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eadaea512833f205f6bfdc0d6bb21d395ce8ac4f5be4c4cccf59d93ea57913dd"
    sha256 cellar: :any_skip_relocation, ventura:        "6801843fa344868acd2e00e37a6a02832f4f576f66af72d69f8e3896a9ef582c"
    sha256 cellar: :any_skip_relocation, monterey:       "fb47a2bb8ed6a56e0b046a887ce0296dd34238f667e280c96e10ef6afff8aafd"
    sha256 cellar: :any_skip_relocation, big_sur:        "223bc95dfbb575b7816d96ba38869baf6d45f43238f4292bcbd09edb07e5aeea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d892b479aae8e5a0312e68c0d8ccdf7489dab0f8fec38c3b828fe0b8d4f9b6c0"
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