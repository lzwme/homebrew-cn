class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.14.4/qxmpp-v1.14.4.tar.bz2"
  sha256 "e5bcc95546e9f1fc5452934f6795dd1f2874e75da9139aa1330436f62f550c31"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bee10b891fc2d262be28313229a0f74b8cc431e36b621fdf8a400a8f6ad17987"
    sha256 cellar: :any,                 arm64_sequoia: "b6a27320056ae94be2148f94c1f2da5d770f75eb9336fa9568eb14d2b9fe728b"
    sha256 cellar: :any,                 arm64_sonoma:  "a4b3477d2e7cc6b4cda2837c12687158ad3adc8d3f9a70b6901961559792a44b"
    sha256 cellar: :any,                 sonoma:        "e10721ab7aae8db4eb9fbc15cd3d867a1c41fad8cf052619130aecbb6a635d8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03f838280c655cdbcb4cc2ac6bf413d40363f914056ee4773308f5f92a3c71e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43717f3203d96967046ca5df1939fee03fbb59e7fc6f819baffe762020539f45"
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