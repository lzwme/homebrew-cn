class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https:johnmacfarlane.nettexmath.html"
  url "https:hackage.haskell.orgpackagetexmath-0.12.8.12texmath-0.12.8.12.tar.gz"
  sha256 "0e05552aa651a438dcbb2b8357310ca7fae65110a071c27db6583528109d0583"
  license "GPL-2.0-or-later"
  head "https:github.comjgmtexmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd840df921600e0cb272cc76300bc0cf14ad5c00f5e9049a23caed8677fab04e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "355ff48a8d1d3609f3db17c4a0172f71a4c34f3bb65e6e15523107e8072f18a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f4dc6add39c8c5dbcfe9a1f8d8b0f2c5fae582f23e1439595aa7ad0e56bf3df"
    sha256 cellar: :any_skip_relocation, sonoma:        "726c61cef9d8ebdf17956e06860b5206b61a18086378e57f4af9f0159620ec53"
    sha256 cellar: :any_skip_relocation, ventura:       "76f9552a8d4f4739e4beeb0e4ba0e33d6672f2704c7de7cdcfb3d4f7fa71cc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "487ce31931b9b1cb566a77d07a321e35c4bb8577e4accc1035ebece3a03db32a"
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