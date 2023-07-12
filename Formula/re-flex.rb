class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://ghproxy.com/https://github.com/Genivia/RE-flex/archive/v3.3.6.tar.gz"
  sha256 "3cca8346aa1e6e56630bbdb7dee62e08c67a0db8e9d5aac467677d136d419b63"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27216c95d152a267682b03f1053168ae5757575c405a111d6c33ef9c598e981e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd3d5be47e8897ec234c227875b7f108a1a289d46e4a237e963f0774e84cb91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ae4cfdc06c84398f7c76d5c22259f3bee55297dd850ae96d6dac715a1a9b51c"
    sha256 cellar: :any_skip_relocation, ventura:        "c25b98a87421c1981d708801cd4b1118e5fdd2e0cf695f47dec95c269585b90b"
    sha256 cellar: :any_skip_relocation, monterey:       "567e2b32b3dc2fb24327d015f369830e77835fa5095161502c43c43704d0103b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb6621ff7902dc2558b5aa45ed183863875949b4c4c7977a809305b64c029e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce921fffc6866bbc413f878df8680a7e1b09a8b090c24f73f23629e48230bfec"
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