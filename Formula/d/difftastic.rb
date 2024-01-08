class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https:github.comWilfreddifftastic"
  url "https:github.comWilfreddifftasticarchiverefstags0.54.0.tar.gz"
  sha256 "04f13ccf32fa55d1835eb9cbaec0a3c062d217a83c049e9a1f16ae3c22ed361a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e05fd43670d86dc1c62edf38c0e6ce474472417adbc0b8362267770bb8c194df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd1babb49656bd6b4ce421c4fd794dae7711012da6b572b88f2cfbf410c8596"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73a0ac5d6fce8ffb81723465daf3378778c0fb65a15953abbb2e8db9140cf177"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f16f85bb8ebdaaf56cfb2887b42fcb867ed7eb9c2e7549466ee9ee620350557"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a63bdedc8cdf3c9fbd6e377e7186630f7d9c51e2009de594d41af9df468e43"
    sha256 cellar: :any_skip_relocation, monterey:       "1e2602f4b7be3a0153912ae56880dcac642a4ffd2c1b8a3cbbc568f400f15d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35e8b588a5233c257523391c812e914805b4207612b79795c7a35892a9618bf"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"a.py").write("print(42)\n")
    (testpath"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}difft --color never --width 80 a.py b.py")
  end
end