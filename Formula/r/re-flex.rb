class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https:www.genivia.comdocreflexhtml"
  url "https:github.comGeniviaRE-flexarchiverefstagsv5.2.0.tar.gz"
  sha256 "d62a2b78c0d777360b7b85e873286ed74a8b685555747f9d0b1409cc10cbcf36"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8829cb7873e6506fc25dfbddb181959dc394b2cbd3425d4c880f91b7b924aa7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58a057c28e24932b90fc15089073305b58a48f87c2b8d89701718828913ff59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41fcc4842cee225e001ace02edd1915552cc451fa5a252e5ea8772a14d7a5eb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b9f1b834986aeefdb4750c064d0e33ca7baabdb9b96060ced801ed46b4cb9a"
    sha256 cellar: :any_skip_relocation, ventura:       "4a0433288b8240a49298d6df475485b461608b7dde693e780a077f6c15211129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "340c44f5dedd530df1a5b08cf722b4fae4bcd42325d7556c045d6e19c324a163"
  end

  depends_on "pcre2"

  conflicts_with "reflex", because: "both install `reflex` binaries"

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
    system bin"reflex", "--flex", "echo.l"
    assert_predicate testpath"lex.yy.cpp", :exist?
  end
end