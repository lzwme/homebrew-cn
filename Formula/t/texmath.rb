class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.3/texmath-0.13.3.tar.gz"
  sha256 "13a2adae4edf4394e15af0a3b825d8cee44b85dce55c21768468aae38bbe1dee"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1a7f790beae56f20b66878b67c56791b6ada17e7b3d8eb8bfa5d4027921511c8"
    sha256 cellar: :any, arm64_tahoe:       "a732f19fcfb03610448709a5e3ef6b8a8ed72a30182106485acb7ac7ab8b72b0"
    sha256 cellar: :any, arm64_sequoia:     "d3eca996565cd9cfea819ed2edaf26260fd382eb6ee75d9a161a4baf492600f2"
    sha256 cellar: :any, arm64_linux:       "b2399810fdbd8075e4c69b1f1893fbacecee545e46e3baff94b5f12423f901f8"
    sha256 cellar: :any, x86_64_linux:      "187ac163ca3a4aca75a6f0e4c73274eb3cfae1f9c5fcd11c2afe47eb420df3a2"
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