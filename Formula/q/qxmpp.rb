class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.16.0/qxmpp-v1.16.0.tar.bz2"
  sha256 "e7ad999bf201cb815916d70833889a1faf6c80cc424cbabd3be5ad182ce663a0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d0b54004e494f4349289d974106ce7cc02e4a2b60288307ccbe07dafa422fd5f"
    sha256 cellar: :any, arm64_sequoia: "a82a232aed883e3484f1469f464cef23748b3e905e3e6c3eae47295a57384e27"
    sha256 cellar: :any, arm64_sonoma:  "b3bb46bb82773bc5cafef624b727b06819cd435ddfa1e7fbd155ee7ea6106fbb"
    sha256 cellar: :any, sonoma:        "4524fa333983692f96c6b67e57d03b64d6390a68248523815c56a5ad4ba5cf3f"
    sha256 cellar: :any, arm64_linux:   "07d33e15be3b690cb89db0080fa3ecf82e705b7c9866b2ef51afe1247e6d5979"
    sha256 cellar: :any, x86_64_linux:  "5bad4bf1d35794f6132a3890d5c6c71faefacfa856ecf8837fbfff56ff2d7075"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "openssl@3"
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "llvm" => :build if DevelopmentTools.gcc_version < 14
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
    ENV.llvm_clang if OS.linux? && deps.map(&:name).any?("llvm")

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