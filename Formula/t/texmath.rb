class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.2/texmath-0.12.8.2.tar.gz"
  sha256 "1707742d2ac98f8a7068bbbac7a395c851d6c3a2f590f60757dbf3931e26003c"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96f82854a7c4f588ba30df0e5b650ed7fc4e696be5568d58a460059a93594ff7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37edcf9718e0f59ba76b3dd89d821335166f0e57597a3e12a79b7a9a3f32f013"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50e8be3a3582da58d72e72a38c2f3baf0299917e5157ffea36cc0c027562ad61"
    sha256 cellar: :any_skip_relocation, ventura:        "ecd1cef0f0e55875559ec4fd31858c1ec68c59e133bced7eb29a9a5400959443"
    sha256 cellar: :any_skip_relocation, monterey:       "1d60cad23ba69e10b24ba0afec9d3b4e554787bd314ecc57c9d3bcfda1cea22f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e7f654f3ac22e41ede6b2b4f880780b4eb66d5bd8fbe643d4dd9f573f6e8595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f29c3bd23a9b9a6baccb4ca9e8c3a4f41fead6d8db979d5a3a13bcf3d41f355"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end