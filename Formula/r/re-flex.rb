class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://ghproxy.com/https://github.com/Genivia/RE-flex/archive/v3.4.0.tar.gz"
  sha256 "ed15f85e25253df2c76c228e0af65a702677175ea92cedc47eed427a25f987b6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f92ce38d44c8b3037faf1a5b796a5d5a946f3852ef5fd87fa7615ef21060657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd6fea604c54c106b1648f77f0e35475c9b190489fd0f0a9892a68de2903526b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a2bfab86c9d1eea035c54a865efa6e05ada0756ffef6c2795fd0cf90611db7"
    sha256 cellar: :any_skip_relocation, ventura:        "1f170aa5dac585935b89de051d876f52742590201c16651ac475eb227c314c7e"
    sha256 cellar: :any_skip_relocation, monterey:       "60dead155f2f7a86f7e8522051212aeaba2e9bbfc418410e40aacd0da64be3cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "56fa22f4b431f8b9762f6a7b3fda7729018f9836d47d31ecb57d4594e12c0aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "807bc6369d430d925dfea49a93242552b9f42030eda1e1c8713993a91a2d1a00"
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