class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https:johnmacfarlane.nettexmath.html"
  url "https:hackage.haskell.orgpackagetexmath-0.12.8.10texmath-0.12.8.10.tar.gz"
  sha256 "c46a622aa57ee0e83d006bbdc2b71ff8ea751e2d578088a23c81d55a258b1ebe"
  license "GPL-2.0-or-later"
  head "https:github.comjgmtexmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b0482981a76ce96a4adcbdbf17a3c870b6b544a90937ba19345fdc798ea5f19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87b5e02e6e6cff411b4970039ba54f2ba6fcfab9179504b86e59cffe912eaa43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deec8a246df60b3820cdc40c03a354bacd092a9948c28a6d4ae11148f869256b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a21a8a0ec135541bc61f0d521978f1da85775f9d429aee804f26da15f3230d74"
    sha256 cellar: :any_skip_relocation, ventura:        "b479200408071dfbb0e41a00b817d82a9f9e24b358e3875b879a35ca5d13f3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "01783539e3f8fe1dba376189b5514dbcbc1763eadc66febc513ab7d5a2ea5e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "537347d351b2f07db2bd2afde52066bb6ce7e94cf5ca8ff78495fd96d2a0b365"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2<mn>", pipe_output(bin"texmath", "a^2 + b^2 = c^2")
  end
end