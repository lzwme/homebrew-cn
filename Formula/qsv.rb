class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.101.0.tar.gz"
  sha256 "fcdf757ea71939cd4774b7e94d126ff1d4340c34bd8c96060624357d26788b0a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7686f721da5b83b65fa75c0fc8fd93dca7788a0b323053fa056ab2988370e5a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c32df5e9e6eceb6ea38a35b364dd3e7e6e3713885c511274e9bf4295c8ba1ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5e8a933ae91a7e86f019ef29787bc5639b79961113313f0ca9e40f0a5d14455"
    sha256 cellar: :any_skip_relocation, ventura:        "e91b7f766c99aec6b605f63e3ec36b819f64a7f8218f7ee58531132743e8cf69"
    sha256 cellar: :any_skip_relocation, monterey:       "01dbd564a621a001f90d551e5d755d73a580bf1c116bfa58ace5ff2ddff82462"
    sha256 cellar: :any_skip_relocation, big_sur:        "23af1e25c173c0c5aa98423b8bddbc8c7a32cca61147f12987d66fce830fc459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b862f00d1e5d75961ed0e05184d2525440f3de63fd5a0fd2591a8c9f8b318f0"
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