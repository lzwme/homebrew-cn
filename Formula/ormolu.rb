class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://ghproxy.com/https://github.com/tweag/ormolu/archive/0.7.0.0.tar.gz"
  sha256 "a9c0513c3aad9ae7e340b8fd62315f4828ad15033b2cf227ea415b0849f099f4"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5edba4e7c35c9375dc05dc0cd9953eec6886bc8d152788c5c1e34863ad947134"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5706bd860b28b8173f4ca9d548a5d3790f6ae608a66ecac5366bd527a4cec36c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "044cc44755ee8347e9c634e2d9a7b8cad538f7c15d93c2a734b0219896fc85ff"
    sha256 cellar: :any_skip_relocation, ventura:        "fc12c1d558d04f15eda723ff0e787aae63303096967913f81afbd367e793ba52"
    sha256 cellar: :any_skip_relocation, monterey:       "d22f2d720acace4f05cebecbdb7c599f39144ab4d34aeb47b627502c7165bdf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9175f185e744292814825f7a7cfdfb16f586adaf97a3ff816a855d2e4a7fde78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4c9d6a2d96fe75077d796bb262556a900a490038b29701a80df81d5e8acf0f9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-f-fixity-th", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    EOS
    expected = <<~EOS
      foo =
        f1
          p1
          p2
          p3

      foo' =
        f2
          p1
          p2
          p3

      foo'' =
        f3
          p1
          p2
          p3
    EOS
    assert_equal expected, shell_output("#{bin}/ormolu test.hs")
  end
end