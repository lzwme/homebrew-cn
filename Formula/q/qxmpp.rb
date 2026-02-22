class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.14.2/qxmpp-v1.14.2.tar.bz2"
  sha256 "aa7535bcd2bc6aa86768cfa2b4c9d9630787611e7f750a03137e7db4177df803"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "482e8fd9cb2183e04626e751e3c0e559220004f0ead1d99b12d8fee854f29d5f"
    sha256 cellar: :any,                 arm64_sequoia: "82d0e4f791e4d8dbb1fb648e8e984455422c8589784c5ea038c4cce469a256f8"
    sha256 cellar: :any,                 arm64_sonoma:  "4deb07cf96433de8635e5502ce787f2cf46fcfd581cdf8a62b5e331cc150966a"
    sha256 cellar: :any,                 sonoma:        "6f89aecff380580c82dbb028d189fa003995bbef7055265576744a385b481a9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20b977491464fd1d1526c91f61ddaa252e54f1c921d4007ec67ba210f91762fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c79346722ac898748168cea28d1ea1f8a9d5a7fae46df5442e08c821acb734"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "llvm" => :build if DevelopmentTools.gcc_version < 13
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.linux? && deps.map(&:name).any?("llvm")

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