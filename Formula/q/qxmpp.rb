class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.9.1.tar.gz"
  sha256 "940b9510ce21ec1daac2047fc2fbbe899d17c868dd872af03c6c8f9b3490b4d6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "f70e267d813451b26a607eb2f2d862af79cbff2e867250c2f00cb612e41c2e7b"
    sha256 cellar: :any,                 arm64_ventura: "c8c99536acde50d5eca7fcd79354f1f512e251f8430afbf8f57540c13204bcea"
    sha256 cellar: :any,                 sonoma:        "8cabcc7518f2dd1504ee72dc534aaf52fd124c8d578e0dd449da3301ac29d721"
    sha256 cellar: :any,                 ventura:       "35dfaecf5bbe7031cf02a4741434326d6382321bb9fed8dbe61646b45b588ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e12f28863dad989751d4c5e74d4b5ee2e9832d51cc04cde0a30c066b4be2b5"
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