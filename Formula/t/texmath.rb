class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.5/texmath-0.12.8.5.tar.gz"
  sha256 "8caba8e206c2bd29bc8c1c008a1020ca6d942533dd2a0b8a4bca366170cb90d0"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81e455ab4ff6bf9043707646598cc7bd80efa17181fbe77c66b24e5e6ef3f30a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b84c8b86330e29435d936ec1927c9f0709867b8161f5565c84656318615fa0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f1c82cdb402155c11265362f8c82ed4e2d9b91c21cbc9f9b7f0a816f6a6d0ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ce3a446f7f35b4829c7b2b3850b3109ba9c1961f7cba871f072c66a60b97223"
    sha256 cellar: :any_skip_relocation, ventura:        "8bc9de42b708e62fc78eb374e58888f5422e9a8c71d12f8658cd2f57df51b0c2"
    sha256 cellar: :any_skip_relocation, monterey:       "8af759743355b8167e5cbd43ad2d6dc3b2f3a07edc889c88d4f9ce377c629cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8d4fa92c9a99ba2d31cf89f31b42ba1be4b6c833360559734845761501f706"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end