class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https:www.genivia.comdocreflexhtml"
  url "https:github.comGeniviaRE-flexarchiverefstagsv5.2.1.tar.gz"
  sha256 "dc94c8838daf74af05cde33793443605d03ab28a72e62a9f0d4be60c2efc85c8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa8a346e51c013bf0947e0c948c882d52a0a20500a37de38139c1ef9203626ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db99d0052d43b206387082f43cd3c8152393521ece1200003cea03c79a8ef26f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed82daf70b7d4e8eb4c4e7f93da8d0e99ef353d819a191a5157a63dd2abf41ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "094f45a5f081adab4f0bf90b4ffd6638fc85579ba288a07b9691fedc5dff2c2e"
    sha256 cellar: :any_skip_relocation, ventura:       "e5621894c7dc8e5f0ded4214c2d8212f6c33b4ab5cf06c981029bfab4f34510b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc040d9cccc3bef2da783ef733ad896a76e99deccc4c434c69b74fd21d67271a"
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