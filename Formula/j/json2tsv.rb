class Json2tsv < Formula
  desc "JSON to TSV converter"
  homepage "https://codemadness.org/json2tsv.html"
  url "https://codemadness.org/releases/json2tsv/json2tsv-1.2.tar.gz"
  sha256 "113e5a7aeb295e7f8135f231cad900091f99aebd6c98316f761d377e9b50fd84"
  license "ISC"

  livecheck do
    url "https://codemadness.org/releases/json2tsv/"
    regex(/href=.*?json2tsv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c11b56c49a1d5b59c1649b9524d63b7e44ec3205e50024decc99c4fd9be50155"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff1e44a2251c7e15b30b0da83a6a5a47b7d1575372c95b934c429ac484acba61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a84d66b1c1a8e36f64657560363d472a0461278a9782d15f4b250f3fadd5c983"
    sha256 cellar: :any_skip_relocation, sonoma:         "5732c14998d7ab8666e00b7b3e3696fb482ea87fe64d5d2aeed9675b468586d5"
    sha256 cellar: :any_skip_relocation, ventura:        "9703a23fa98d4ef797b35b6a3a1fcd338725489db90e477d53dc39ad8ee2f9ba"
    sha256 cellar: :any_skip_relocation, monterey:       "470c686211ab55c5e4637c46d0a2b61b1a4453ab89053d145b612bc50728053c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e86703c3724095305d07a924a8a8b69a919959df6f0456cb85d1442023c989e"
  end

  conflicts_with "jaq", because: "both install `jaq` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANPREFIX=#{man}"
  end

  test do
    input = "{\"foo\": \"bar\", \"baz\": [12, 34]}"
    expected_output = <<~EOS
      \to\t
      .foo\ts\tbar
      .baz\ta\t
      .baz[]\tn\t12
      .baz[]\tn\t34
    EOS

    assert_equal expected_output, pipe_output(bin/"json2tsv", input)
  end
end