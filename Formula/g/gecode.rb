class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https:www.gecode.org"
  url "https:github.comGecodegecodearchiverefstagsrelease-6.2.0.tar.gz"
  sha256 "27d91721a690db1e96fa9bb97cec0d73a937e9dc8062c3327f8a4ccb08e951fd"
  license "MIT"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:  "1ac6be371a0a82f7edd1a5468d8d5931b1a3cd1afb86550496017516a62299e9"
    sha256 cellar: :any,                 arm64_ventura: "b088d88dd7342d07bfa214dd0f955b1f846ce91c6d6eb479249ad21b99c244f7"
    sha256 cellar: :any,                 sonoma:        "10702edcc3d8e3b168846bf2d3126937c369b191dd6b859adc477af3540a2b9d"
    sha256 cellar: :any,                 ventura:       "d7a6aa6f04979ef458d086d8fa543a5130209d122e37542c9f3494912f94cbcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad8b1f55cda826d0c844f5a243c6af5d0ca16fa8e5b6af0bed593f1821939c16"
  end

  depends_on "qt"

  # Backport support for Qt6 from release6.3.0 branch
  patch do
    url "https:github.comGecodegecodecommitc0ca0e5f4406099be22f87236ea8547c2f31ded3.patch?full_index=1"
    sha256 "233b266a943c0619b027b4cb19912e2a8c9d1f8e4323a3627765cb32b47c59fe"
  end

  def install
    # Backport parts of upstream commit[^1] and add workarounds to allow configure to build with Qt6
    #
    # [^1]: https:github.comGecodegecodecommit19b9ec3b938f52f5ef5feef15c6be417b5b27e36
    inreplace "configure", "if test ${ac_gecode_qt_major} -eq 5;", "if test ${ac_gecode_qt_major} -ge 5;"
    ENV["MOC"] = Formula["qt"].opt_pkgshare"libexecmoc"
    ENV.append "CXXFLAGS", "-std=c++17"

    args = %W[
      --prefix=#{prefix}
      --disable-examples
      --disable-mpfr
      --enable-qt
    ]
    system ".configure", *args
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <gecodedriver.hh>
      #include <gecodeint.hh>
      #include <QtWidgetsQtWidgets>
      using namespace Gecode;
      class Test : public Script {
      public:
        IntVarArray v;
        Test(const Options& o) : Script(o) {
          v = IntVarArray(*this, 10, 0, 10);
          distinct(*this, v);
          branch(*this, v, INT_VAR_NONE(), INT_VAL_MIN());
        }
        Test(Test& s) : Script(s) {
          v.update(*this, s.v);
        }
        virtual Space* copy() {
          return new Test(*this);
        }
        virtual void print(std::ostream& os) const {
          os << v << std::endl;
        }
      };
      int main(int argc, char* argv[]) {
        Options opt("Test");
        opt.iterations(500);
        Gist::Print<Test> p("Print solution");
        opt.inspect.click(&p);
        opt.parse(argc, argv);
        Script::run<Test, DFS, Options>(opt);
        return 0;
      }
    CPP

    args = %W[
      -std=c++17
      -fPIC
      -DQT_NO_VERSION_TAGGING
      -I#{Formula["qt"].opt_include}
      -I#{include}
      -lgecodedriver
      -lgecodesearch
      -lgecodeint
      -lgecodekernel
      -lgecodesupport
      -lgecodegist
      -L#{lib}
      -o test
    ]
    if OS.linux?
      args += %W[
        -L#{Formula["qt"].opt_lib}
        -lQt6Core
        -lQt6Gui
        -lQt6Widgets
        -lQt6PrintSupport
      ]
    end

    system ENV.cxx, "test.cpp", *args
    assert_match "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}", shell_output(".test")
  end
end