class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.91.0.tar.gz"
  sha256 "3453be7b49cb97f391806dcb705ab3b44786dd58b776f1f09a44d56f6bef6d91"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de8d6340d5edcc81ce341fcf0c9c127b819d198349c01f8c273f0c07c014999e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7960c9b8287ba0f6809318d20f63f6afacd6dd4ad9801df6742f86c75aea001b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17df9a5b7ce7eda695a19d01307d74785ba044d1fcdf2abb439f1df386363d1c"
    sha256 cellar: :any_skip_relocation, ventura:        "bf2610818d35e0413267e36c50fa818ad5df5257998da4ed900d0f1b1ec364dd"
    sha256 cellar: :any_skip_relocation, monterey:       "9f498819a9c79d274666d341fbe8698483ed4b032129ec1a2f8fec302132f6ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a6e6dc37f73df3f648aa51e335414df75941ddaeed1fbb84caaaaf5393d3c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cd84ebda51df1526f28bd590226c32ab89158645d767ca727b53439edd02ebf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
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