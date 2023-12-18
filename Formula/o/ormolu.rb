class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https:github.comtweagormolu"
  url "https:github.comtweagormoluarchiverefstags0.7.3.0.tar.gz"
  sha256 "dfc3cd77ad55e80719a80583f0a0d753b7f6061fe1f1fc49f6805cbb06452c0c"
  license "BSD-3-Clause"
  head "https:github.comtweagormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4716fa363194d0d5d29efb2767491e2225a32a1ba00401dce93983db6de63ffa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "181ab611423b0ce0febc61e759748639e5a952d044e15ea7e5f9227a7a9561ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5a5b5b2c187aa54611920363a03395b0ef21df36aa02784f2e7f452cec968b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e8de20e723c0934308a8bb1ff484e519e2e78192082ead8dadfb4fa49c1153f"
    sha256 cellar: :any_skip_relocation, ventura:        "c082e04b30e5132968c6618484b34227d0b3b669d857155888684fc221d3d638"
    sha256 cellar: :any_skip_relocation, monterey:       "f3883e8bbc2eea2c319cf0b6a8d3b7e42d5ac55aac4e694200df04fe08c91225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7372e5876e9d9f6d2fc0d0b7fa06f817061829e29665f5bf56bdf25bb1e17b87"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-f-fixity-th", *std_cabal_v2_args
  end

  test do
    (testpath"test.hs").write <<~EOS
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
    assert_equal expected, shell_output("#{bin}ormolu test.hs")
  end
end