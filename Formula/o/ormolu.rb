class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://ormolu-live.tweag.io"
  url "https://hackage.haskell.org/package/ormolu-0.8.2.0/ormolu-0.8.2.0.tar.gz"
  sha256 "9ce1e8a1cefe21c7588b3d7ab3d26f353cf6a63cf68576eee203df144aec04f2"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d48137c3a02dc12cbb6d0fa2b1d71a3cea22d172ab0e252048537fd2ca7f1962"
    sha256 cellar: :any, arm64_sequoia: "12bd05ddf34abb28f63949f16ae03fcbf903d05c3631b414672d914f925adca8"
    sha256 cellar: :any, arm64_sonoma:  "ebce97d0261971e53cb4a3e1b4d0c7f6e23274b80a4435d866c0e9210ae68141"
    sha256 cellar: :any, sonoma:        "e7401217b13512fabfb3025dfbd0190da972147dc833a342f04cbdaea914395a"
    sha256 cellar: :any, arm64_linux:   "d1098eca95a2ea3a7c2d471bb1ed1a6547eebb507b9fd182ce0167cf2cd1a609"
    sha256 cellar: :any, x86_64_linux:  "22d992fc32b484eeaae4a3c6c99d937b37469e285fc934c96d326ff3ef3fa668"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
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
    HASKELL
    expected = <<~HASKELL
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
    HASKELL
    assert_equal expected, shell_output("#{bin}/ormolu test.hs")
  end
end