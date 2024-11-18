class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.9.0.tar.gz"
  sha256 "1b791c53d32e38c7f612b4a1d54f35b9db264501be2b3d07ef927af73e2f7d0e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "d986877c85758a24b078bfb0a5e7b92bfa711b8e8fa1167a6be1a38383062b84"
    sha256 cellar: :any,                 arm64_ventura: "53a46feb30e65c987ef315f68ad7e3d70bc1ed03fc7a626ad6ddd34849e74758"
    sha256 cellar: :any,                 sonoma:        "b0a56178bcea8eea542491ea70ca864f75dfec260abd43529a6f0562d22b7777"
    sha256 cellar: :any,                 ventura:       "19f57652e4a3d4c7f204a8be8ad127c656bb04939aee19870f2d6d87df97d153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec94ff4686db3cc45b68e9e2f48530c5738a0eada1785b149c497f6644ecafb"
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