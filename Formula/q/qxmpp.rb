class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.10.4/qxmpp-v1.10.4.tar.bz2"
  sha256 "92d7e491be736598b2ef20250b5a5e387df584f4a61e0b5d34a3536fa99b3e72"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e3315ffad1d2eed41b393e66e6e34e0ad3c1ecd6cdda8217e69284c34e1c8af8"
    sha256 cellar: :any,                 arm64_sequoia: "eb9a95ada615537a5833fe7f09ad83449b2febfb1a61c3b2b7ca20ec77df2459"
    sha256 cellar: :any,                 arm64_sonoma:  "7b2b2678dc52cae05cbfd51cd4104b18071352f2518b299d006880cb250ccf8a"
    sha256 cellar: :any,                 sonoma:        "c681cac483afb629b74f44ee126b04da4b9f74e938701e01214c000f8ce2473e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "864a83aea847d857299931bdc114931287d035c2375306b812bf01d97d2d7287"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qtbase"

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
    (testpath/"test.pro").write <<~QMAKE
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
    QMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <QXmppQt6/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    CPP

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end