class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.105.0.tar.gz"
  sha256 "24ec8e73b957494e296fe20cadd8c11a4e431986c3ded9eb60fe3fcfbd70b983"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27be71f42c7fdbf087f569397c58b304adc30a62513edc5c161dc7ee5ec9bb7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd687a6a71848bc88ff5b71e658f0f7bff301c72d62fe3ed2648c2e7093d838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ed4df15d17784bfcbe9d88362062c6fca66563ac5609766f2797c7f472829a4"
    sha256 cellar: :any_skip_relocation, ventura:        "6981a8970f9acda1a558c9c3fca3f72fa965a0377332d97a8923bc56bf9c2df6"
    sha256 cellar: :any_skip_relocation, monterey:       "f069ac4782e77caf8242f09671776c597048f722dd918fb8aa15fa99f3643635"
    sha256 cellar: :any_skip_relocation, big_sur:        "15bb121c66fef54545226eec97dbcf97f33386bac5fdaeab7f5ee1b5fa565296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994af7c39c8a71bba6cfcf0bcff20226e26a36681cd3b4fc8079ea38f6401433"
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