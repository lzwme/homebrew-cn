class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.8.2.tar.gz"
  sha256 "5964468778c743ae336ebc14af9fda1afcc1128acc94d9500f4276614e5a1425"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "bd14a8a94fe220e843200579128373861499269b7fe0932c9acd2465ea2153cd"
    sha256 cellar: :any,                 arm64_ventura: "714ba1209370b70b1f92abc98030866556ea797311293d7760f0e123a539e805"
    sha256 cellar: :any,                 sonoma:        "23eae4da04462126fcff9d3ebf2bbcc4cc7e8f7c377bbd0cf2756cba0cc40be8"
    sha256 cellar: :any,                 ventura:       "db174b4e53befb9d210aa2b6ed694f2dc89c75518863380ff3829d2de2c15da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c19e940fd935469e42e41aa277b713fff0523bdd9970dbf4c701e326352e1af8"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV.delete "CPATH"
    (testpath"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lQXmppQt6
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath"test.cpp").write <<~EOS
      #include <QXmppQt6QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}qmake", "test.pro"
    system "make"
    assert_predicate testpath"test", :exist?, "test output file does not exist!"
    system ".test"
  end
end