class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.3.2/texmath-0.13.3.2.tar.gz"
  sha256 "64dc5357ec7aa51d3e1e39c8f2da1e8a5f307f2bee98c35e521d134a421ad435"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5b5f891885d4232b517884c92d749bd2482bd338861e9d41f033f704b59f5293"
    sha256 cellar: :any, arm64_tahoe:       "ac7791baa2a58cffa55b170a3624888cf93ab7263dc56229612c1d2b6506cfd8"
    sha256 cellar: :any, arm64_sequoia:     "734a9bc159f1cb265bbb2525ad356535c66ad60ada809829818d79557becf400"
    sha256 cellar: :any, arm64_linux:       "759df06f297c91e14b9411cbba950847bdb3205f9801abbba4cc2bae6cfdb653"
    sha256 cellar: :any, x86_64_linux:      "a8f73f651e4af3577403bfa61415eb662805fe4233783899f9179c7750c3b368"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  deny_network_access!

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", "--flags=executable", *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end