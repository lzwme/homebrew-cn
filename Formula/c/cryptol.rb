class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://galoisinc.github.io/cryptol/master/RefMan.html"
  url "https://hackage.haskell.org/package/cryptol-3.5.0/cryptol-3.5.0.tar.gz"
  sha256 "7341c026ef83b18d2c784cfedb37003f74d1560605cd9c3107b5b6fc31fb2f84"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abc50844f6f17229e4d89374e796689549d2938848fd9b39ab7088dfe8d9a4c8"
    sha256 cellar: :any,                 arm64_sequoia: "ed88879126b6f7ebffdce0e2b0aff084095b922f32d0290ddc2d75dfdbecf449"
    sha256 cellar: :any,                 arm64_sonoma:  "362b7e5d404bac1a7c558dd8cb788dc62f7511124436be2cb7ce260f22a46a15"
    sha256 cellar: :any,                 sonoma:        "3234c9879025e99ce9451bf4d99710f56e6ad2d16b6883b9d3730c509551d1d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eaa0d6b6a8dfe2a66a3a089f9c5fde964e3ab32052b24932da89d8ad562bc22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "451ebb357c1707fae8b2eb55f432c900e4775dba328f8398d2074e2c82d2b636"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "z3"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end