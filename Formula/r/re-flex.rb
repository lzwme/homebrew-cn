class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https:www.genivia.comdocreflexhtml"
  url "https:github.comGeniviaRE-flexarchiverefstagsv4.3.0.tar.gz"
  sha256 "1658c1be9fa95bf948a657d75d2cef0df81b614bc6052284935774d4d8551d95"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6b15acd7f8baf28313495bc9283af42168e1c41722539b8c42105af76c0cc87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5e8436f4e4c50e6c77f1514e0eb9fdba49ebcdbdd5a406c44ee0ec94af97f04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09df0cc097a0f07c44c020f142b3f7b240e25bbb1f576f214fb1f5d50f5ed1e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa88123dced73a2c4cacfbfd250dc26f0af7d50ecaabd6cd7b58fb4d221c004e"
    sha256 cellar: :any_skip_relocation, ventura:        "c66f8e241fa8b8ab5ea1d5ba0d44e2d44bcf752c966f6ceaf2eaa813e7397fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "0bcf2eb784275ebcd2055536e169bf957ffe0a4f84b2b9e42afa925291e3c16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204f7309311e98f5acbbd68c9083c03d7bc1d7051a999fe9a10ba42f9437b12c"
  end

  depends_on "pcre2"

  def install
    system ".configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath"echo.l").write <<~EOS
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system "#{bin}reflex", "--flex", "echo.l"
    assert_predicate testpath"lex.yy.cpp", :exist?
  end
end