class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.103.0.tar.gz"
  sha256 "15356cd93f82f902667c51a2c3a49f5817507ced8d37b5f5291021c231455288"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cfb89a260c610d02999cf9baaae1e388ba1c5e3da27508952fa84f679ba4511"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f943f79fb4ac6e7a9bf1e8eafb01756baedb8087d18f4fd61e87b238d286106"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3907a391a97edecaf6d5cbf02c80cb4f18560ab4a89f80c7b58c8badccb64de4"
    sha256 cellar: :any_skip_relocation, ventura:        "906a978e18a411ebcb5d0916d1185c1586b23b4679f10447968f4e0567a1a282"
    sha256 cellar: :any_skip_relocation, monterey:       "71d3c4886358a471082921e60d7eab6a4a2f2abef6b5d10581456e3fdca51316"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4daf94c1e855c52e838cedf010ac814747163b1ad4301c9a9576ebc5eff7f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8310a40668cad17eaa079aeccb2574055fbd9401494c8a8fe675a069ea7cd60e"
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