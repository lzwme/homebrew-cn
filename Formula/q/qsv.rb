class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.125.0.tar.gz"
  sha256 "fa6af5c222ba8e0586f0b5a1109341fb41557ce669b3da8c3c30cdc3bf7ea17a"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "074ac0b8fad4d0e8d0cb8db509786f96ee69fad9042f23a17f5175342470af5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86d8dfd01dad800ae7906b0e2f2e422f99d98b55d81f1bdfe8bafef91004da37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2355385595bb8cd9cd07fc7870af3965cfae69a752daea764dc1db0790cd2900"
    sha256 cellar: :any_skip_relocation, sonoma:         "87fa99a71f855a277ae7f01841c2cd1570a7d655b292ddadd781b52a696b4ed9"
    sha256 cellar: :any_skip_relocation, ventura:        "6168f3b2d6f60818cfd3e3db45f66a0d0e3729c0062134e41c9e9fd965abe3cd"
    sha256 cellar: :any_skip_relocation, monterey:       "5dfe7f7af22c0f7558fec6eef94a982d8252f684f3c502773d5d44cdb8f79b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f38e7c46b42e9358392aba9d534f2c9b1c9ef6f9672a91e58c34c7036b2d95"
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