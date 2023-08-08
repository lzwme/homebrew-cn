class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.111.0.tar.gz"
  sha256 "d85bfeab3560865eb313de73f940242807af1eeacb628b99eb67a5566291b050"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb372bf8e171ece1826819f9556d473ec149c5134e06fe1d722d31b7fe38d42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03d526f519e6eb44ed8ae8deeb05e4ea081973129b2b230c99b20f869cb4ff48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8db11ff59b4af86de4469cf04d433c41c930792d2fa078999ce7aeaf396b7612"
    sha256 cellar: :any_skip_relocation, ventura:        "822a6cd662f9a25676cbc329b99f1445b68f30431d9c706add3db65b1051995a"
    sha256 cellar: :any_skip_relocation, monterey:       "ba9d6f309369fec87692c0bb04d1cc33f2842bc0af68885961d3a18fefc852bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "727e18d13b23acbd81b707dc111a0326f0dab06e5c4d649fc91b0cafad1e159f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb10f015e9025823740135e3594ebd6d0a40eba9a891415c898c4afaf591c36"
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