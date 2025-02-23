class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.10.0.tar.gz"
  sha256 "04117461cc608af74ab299a7b96be4e38efbb0b67f50839fb59b17f3903725ee"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "b08da35f296845ef3808e1f58edfa30b26c0e28e29cc9a9a91859e28d5d85d91"
    sha256 cellar: :any,                 arm64_ventura: "905e757d7ddfcc6ab81fbf026002ef175830d04ced2abb9c2afbd70ef8fd6960"
    sha256 cellar: :any,                 sonoma:        "403c0c5f5c6ad4e3ebf9ea05ae835eb10e643d57d6d3e1b72d47af0882507c52"
    sha256 cellar: :any,                 ventura:       "ed7fd65cefca9335950593162d8708db379f2c9db3ff478c705eb25b8ec13c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff94a67bf15b68d02cef1c7cff8d55c741205420938dfc1a7e9b158aefee2f2e"
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
    assert_path_exists testpath"test", "test output file does not exist!"
    system ".test"
  end
end