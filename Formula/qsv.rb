class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.90.1.tar.gz"
  sha256 "c144e64fbb0650518e1bd37926ede565d467c5bd5ad4d78f46543eaf3ec83fc6"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceaf74479aca8e81cfc7530358dc2d9e46b8f1d940b6e782b204acdbfd35576c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89b298d28d1fd0b9bb1e7e5e11a355fff5e4ed71a2b1f64a638dbd2ce468cfea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fefed2a96eb76d2a9aa3706f1559cdf34dfdc23bea4ef0a7cc85eef2df969fca"
    sha256 cellar: :any_skip_relocation, ventura:        "d0e0bcc9b4d53c9cb5b86f0d05d04aec02af103c60adecadf5fb0ec1988abc6c"
    sha256 cellar: :any_skip_relocation, monterey:       "99cd393b3e136915353ed115c23ef15a4114ba5773d1478bfd198df0aa6c7eaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d54f68030ad42732f8a2a3a94a98d0ac2b32dc373231bff0cf454980f1104bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22c4696de281d175539ed150f14293c89a4cb778584254b35765f4123762bf8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
      second header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
    EOS
  end
end