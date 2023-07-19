class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://ghproxy.com/https://github.com/Genivia/RE-flex/archive/v3.3.7.tar.gz"
  sha256 "84e1335e805b9a0248c277910043988bd53ecf00a5d49d235bde71b11317601d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "179bc7902da6bfab48a5a110b1196cc83b7556a4bbcd68078c672598226285de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c5b25ccb3f87603e1f7966cac3f1c9d89c7e477e3e88fdb7816034d9d72fb5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "032af07adc9819682e12cc27714c2f93329934dcc67d2380c8885d2b86c203a8"
    sha256 cellar: :any_skip_relocation, ventura:        "854f3555a196c5cd94fc165195d373fbd59e2023edf53305cd8e665c86a44c35"
    sha256 cellar: :any_skip_relocation, monterey:       "1538c12e25af9d342a388a78baa3617060f2bcaf929102da33a848c662056930"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cdfc9ab7c7a5a2f65da55e62330967b393e70e0f8c38798b20c89e73a76e786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e784d7fb74e155befc267f491e0740b5743a37f1c7a43ecc4c9750695a09b91"
  end

  depends_on "pcre2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~EOS
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system "#{bin}/reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end