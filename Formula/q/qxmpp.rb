class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.9.3.tar.gz"
  sha256 "6331561ae5cdbd7f850e4e886b8f42796d630a69b94252cae87fd67edb7adf7e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "74c1d0171dbecca9959ec4b578e261a76d7ba38e1f3b85cb2f8872edd304f264"
    sha256 cellar: :any,                 arm64_ventura: "4104e0270cefe016bfe0582c9ff698e586ed97d746d08c64499307c7bad87895"
    sha256 cellar: :any,                 sonoma:        "d6e5850d7638aca9dd9f12400f36a88880f166a8e014daf6ec78e519f7105fa1"
    sha256 cellar: :any,                 ventura:       "1671c757b011278a346eda14b7ddf335679a572dc595cee5eeff4ce170c50e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf76b9782a3fb11b9b76b1780e73cfd7e392692cced5f411f2fd073c9fb075bf"
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