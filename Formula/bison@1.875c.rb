class BisonAT1875c < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://alpha.gnu.org/gnu/bison/bison-1.875c.tar.gz"
  sha256 "5974d9fbab4ed01f7d843c75ef442080a62defbd797adcc029aef80b301f30fd"

  keg_only :versioned_formulae

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-relocatable",
                          "--prefix=#{prefix}",
                          "M4=m4"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end