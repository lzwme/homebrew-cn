class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://ghproxy.com/https://github.com/Genivia/RE-flex/archive/v3.3.3.tar.gz"
  sha256 "a91f39c938accbd8a349b8ec627542b6f1516b1d7e999b4af9529a84cf53dfcc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbdda5cc7c459498d4589e579c093352aa4f32949c17fb355f323712a2a5bfbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e525d5274dc003dba495c96b9442650f86a9ddde754ca15c7c76fbc87d6b8073"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8b1675cbd694405ac3f544c612a993b244af88a86a1bdfe847ddf8543dfbe60"
    sha256 cellar: :any_skip_relocation, ventura:        "7f84698c90af2d2f88783164faf232491b3637a582009f84990ee86fac093e1e"
    sha256 cellar: :any_skip_relocation, monterey:       "2885ea7a168f4e3a1a68752245034c544c37c1d71a2e49f0e5873de1804a5727"
    sha256 cellar: :any_skip_relocation, big_sur:        "69d9380a326154a3ea1aa9f7a0b6baf7b4a8eb8dfcf85afc34b50d45f34d7232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1cfa818059ff5d1618420bc6bb95d28ed653346cc7d71c753e60a00afe88c71"
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