class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https:github.comvtereshkovumka-lang"
  url "https:github.comvtereshkovumka-langarchiverefstagsv1.5.3.tar.gz"
  sha256 "03b69332644c60979ba2d2e5956efd22aff3cfc2e910f14f49a8ec89ef8d5cb9"
  license "BSD-2-Clause"
  head "https:github.comvtereshkovumka-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "619485bf5111fe84290708d9cb36087218f6c1c86f93a20e84572b08bf7a8147"
    sha256 cellar: :any,                 arm64_sonoma:  "8328857fea1931da5dfdc487a0b2ffd5d12e94401030502d2bfb968378da3eb5"
    sha256 cellar: :any,                 arm64_ventura: "418314a8adc1c93e4c0e6400ea30672664038991510fbfdc0c11a3a71f507d0a"
    sha256 cellar: :any,                 sonoma:        "be7676e4e428a30af843522db044123aaa4b802e332c6cf0e9d23de034d7d013"
    sha256 cellar: :any,                 ventura:       "e49db55cf30c555f77ce8369c390a7cc3de87357e85de67d473193491bba43d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c27a893352932034b036222eaffa57f761c6f1595734480031cfad76e87049"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"hello.um").write <<~UMKA
      fn main() {
        printf("Hello Umka!")
      }
    UMKA

    assert_match "Hello Umka!", shell_output("#{bin}umka #{testpath}hello.um")

    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <umka_api.h>
      int main(void) {
          printf("Umka version: %s\\n", umkaGetVersion());
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lumka", "-o", "test"
    system ".test"
  end
end