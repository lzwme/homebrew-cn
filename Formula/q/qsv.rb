class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.121.0.tar.gz"
  sha256 "a1dc412dfe1019d7b42aa3340209d4594d3650586ed1efc021786f1777ce0a04"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a068096b99dcd200f1e3fad054e5e8aa15bd98a9adec5c1c7797b5ac1ec5e20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90054092eb303dbd7bce1adc1bb81a27782ff9a39759ffb4d00fc73a66d8f1e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9af134f15c85253d09db36210c952d2cf531008defc5c6eaa89fa105a2f27ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1c503074efea727d0b96baa229857bb33a1c03186bdb0f87481076e0db94f78"
    sha256 cellar: :any_skip_relocation, ventura:        "44e9bce75dac7058fa4450b70eb33b406c3b675f1d189d114fb52ef34991f8f3"
    sha256 cellar: :any_skip_relocation, monterey:       "d97d567a7f470d036c19f88f62dabaebcd7d6b119bb84ad42e385f39acc80b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "902c4aa7849ec11f85a88b904d3c8d6906d94a206030f298877d7e5fe5c12145"
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