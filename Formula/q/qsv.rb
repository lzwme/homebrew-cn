class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.126.0.tar.gz"
  sha256 "ee38f1ca972c6bf50ad3e973a0b0fd11b784d9abf8a6eaf97cc5c1a582c9fac1"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90f9073cf188c2dfc6a0ca00473794e9632e2593e5b857008ee92b1363fe155b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6a658e21a93e0a0e5ad9d480522a9e2720a4e649d81665ea1863417bb2d0488"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "789641dba204bee55c4dc2bea72c5a873f4dcc6ba9903a0a5a487be5ad4c1138"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6090f0d955d5e1280af62c560bbd880c8cbf81db4be77c5fa65b80d1325c75c"
    sha256 cellar: :any_skip_relocation, ventura:        "e249e5b29d1e0df59c715245d12d013af3e7b55fc110623b8b70481c5fa38f88"
    sha256 cellar: :any_skip_relocation, monterey:       "6cffd142cd54bf7618dced743a05d0a55ce29e49ebd0c9f1e33bc828f20e5d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6e86266c94bc650ea0231dac80d2a15bc45cd9d26b13ca4ab76a79531b5bda"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end