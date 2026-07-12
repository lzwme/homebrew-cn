class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.16.2/qxmpp-v1.16.2.tar.bz2"
  sha256 "9245bcf5e78d986f685fe5f05fab5955cc0773a8d7edfbc6b237df47a1c17573"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "76ae49d192d5ff88ebeb4d93eb528db704b2bc4d10e41ea17815b74790eaceec"
    sha256 cellar: :any, arm64_sequoia: "84544d10e30f99859b6cfc67616ad4abf902b6ca1ef0446e0309574977458ac2"
    sha256 cellar: :any, arm64_sonoma:  "b831cf969d318169e15267c90231e8e31b901e5786927c47c748dd586e988b0f"
    sha256 cellar: :any, sonoma:        "114f30d4514f91a0b5cc62f0606f8ad2ba69e26c807c9afb1bd159b1ad4859e8"
    sha256 cellar: :any, arm64_linux:   "6d86a5f730fc8a93b5040aff285e617d105db62434449d12e19d488fbc913b29"
    sha256 cellar: :any, x86_64_linux:  "98c2455e80e5d981e66b0533baeed982a1d02342382dc2c4debd0020b7eded3b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "openssl@3"
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "13"
    cause "Requires C++20 and GCC 13 crashes with ICE"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_DOCUMENTATION=OFF", *std_cmake_args
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