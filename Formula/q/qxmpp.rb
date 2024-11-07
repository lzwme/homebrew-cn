class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.8.3.tar.gz"
  sha256 "0696376eb2e9c601bd4835da8b3c45a01cab622fa47aea5bf937a7969254da40"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "eeca58f81377863e9744f18789d9b998df9ad3f48757f1d27e956a4fd3f3d67f"
    sha256 cellar: :any,                 arm64_ventura: "c3245ea7e580105d0e8d49a878cb5e700662873ec0160756b68885438ede16a5"
    sha256 cellar: :any,                 sonoma:        "7d393e56a8f75517696459a8d6778e5768781435fec954506177643e9c6fe2d9"
    sha256 cellar: :any,                 ventura:       "0edf0f9ad1ae2ea5c7147a7d5c472966d00f4e56c9eaf4b35175917f53fba5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "012003d5061b6160bf8158e30962aee6d0457d1060d4cc4d51b654cef561ed2d"
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

    (testpath"test.cpp").write <<~CPP
      #include <QXmppQt6QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    CPP

    system "#{Formula["qt"].bin}qmake", "test.pro"
    system "make"
    assert_predicate testpath"test", :exist?, "test output file does not exist!"
    system ".test"
  end
end